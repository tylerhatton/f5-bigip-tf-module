# Admin Password
resource "random_password" "admin_password" {
  length = 16
  special = false
}

# User Data Template
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars = {
    bigiq_server     = var.bigiq_server
    bigiq_username   = var.bigiq_username
    bigiq_password   = var.bigiq_password
    license_pool     = var.license_pool
    bigip_passsword  = random_password.admin_password.result
    internal_self_ip = data.aws_network_interface.f5_internal.private_ip
  }
}

# EC2 Instances
resource "aws_instance" "f5_auto_demo_ltm" {
  ami                  = var.AMI[var.aws_region]
  instance_type        = "t2.large"
  key_name             = var.key_pair
  user_data            = data.template_file.user_data.rendered

  network_interface {
    network_interface_id = aws_network_interface.f5_mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.f5_internal.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.f5_external.id
    device_index         = 2
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
    curl -k -u ${var.bigiq_username}:${var.bigiq_password} -X POST \
      -H "Content-Type: application/json" \
      -d '{"licensePoolName":"${var.license_pool}","command":"revoke","address":"${data.aws_network_interface.f5_mgmt.private_ip}","assignmentType":"UNREACHABLE","macAddress":"${upper(data.aws_network_interface.f5_mgmt.mac_address)}","hypervisor":"aws"}' \
      https://${var.bigiq_server}/mgmt/cm/device/tasks/licensing/pool/member-management
    EOF
  }

  tags = "${merge(map( 
          "Name", "${var.name_prefix}-F5_LTM"
      ), var.default_tags)}"
}

# Network Interfaces
resource "aws_network_interface" "f5_external" {
  subnet_id                   = var.external_subnet_id
  security_groups             = [aws_security_group.f5_auto_vip_sg.id]
  private_ips                 = [var.external_self_ip]


  tags = "${merge(map( 
          "Name", "${var.name_prefix}-f5_external"
      ), var.default_tags)}"
}

resource "aws_network_interface" "f5_internal" {
  subnet_id                   = var.internal_subnet_id
  private_ips                 = [var.internal_self_ip]

  tags = "${merge(map( 
          "Name", "${var.name_prefix}-f5_internal"
      ), var.default_tags)}"
}

resource "aws_network_interface" "f5_mgmt" {
  subnet_id                   = var.mgmt_subnet_id
  security_groups             = [aws_security_group.f5_mgmt_sg.id]
  private_ips                 = [var.management_ip]

  tags = "${merge(map( 
        "Name", "${var.name_prefix}-f5_mgmt"
    ), var.default_tags)}"
}

# ENI Data Sources
data "aws_network_interface" "f5_internal" {
  id = aws_network_interface.f5_internal.id
}

data "aws_network_interface" "f5_mgmt" {
  id = aws_network_interface.f5_mgmt.id
}

# Elastic IPs
resource "aws_eip" "f5_mgmt_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.f5_mgmt.id
  associate_with_private_ip = var.management_ip

  tags = "${merge(map( 
        "Name", "${var.name_prefix}-f5_mgmt"
    ), var.default_tags)}"

  depends_on = [aws_instance.f5_auto_demo_ltm]
}

# Security Groups
resource "aws_security_group" "f5_auto_vip_sg" {
  name        = "${var.name_prefix}-f5_auto_vip_sg"
  description = "Allow inbound HTTP and HTTPS trafic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "f5_mgmt_sg" {
  name        = "${var.name_prefix}-f5_mgmt_sg"
  description = "Allow inbound SSH and HTTPS trafic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
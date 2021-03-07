locals {
  admin_password = var.admin_password != "" ? var.admin_password : random_password.admin_password.result
}

# Admin Password
resource "random_password" "admin_password" {
  length  = 16
  special = false
}

# User Data Template
data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")

  vars = {
    hostname            = var.hostname
    bigip_passsword     = local.admin_password
    internal_self_ip    = data.aws_network_interface.f5_internal.private_ip
    provisioned_modules = join(",", var.provisioned_modules)
  }
}

data "aws_ami" "latest-f5-image" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["F5 BIGIP-15.1.0.4-0.0.6 PAYG-Good 25Mbps*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instances
resource "aws_instance" "f5_auto_demo_ltm" {
  ami           = data.aws_ami.latest-f5-image.id
  instance_type = var.instance_type
  key_name      = var.key_pair != "" ? var.key_pair : null
  user_data     = data.template_file.user_data.rendered

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

  tags = merge(map("Name", "${var.name_prefix}F5_LTM"), var.default_tags)
}

# Network Interfaces
resource "aws_network_interface" "f5_external" {
  subnet_id       = var.external_subnet_id
  security_groups = [aws_security_group.f5_ext_vip_sg.id]
  private_ips     = var.external_ips


  tags = merge(map("Name", "${var.name_prefix}f5_external"), var.default_tags)
}

resource "aws_network_interface" "f5_internal" {
  subnet_id   = var.internal_subnet_id
  private_ips = var.internal_ips

  tags = merge(map("Name", "${var.name_prefix}f5_internal"), var.default_tags)
}

resource "aws_network_interface" "f5_mgmt" {
  subnet_id       = var.management_subnet_id
  security_groups = [aws_security_group.f5_mgmt_sg.id]
  private_ips     = [var.management_ip]

  tags = merge(map("Name", "${var.name_prefix}f5_mgmt"), var.default_tags)
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
  count                     = var.include_public_ip == true ? 1 : 0
  vpc                       = true
  network_interface         = aws_network_interface.f5_mgmt.id
  associate_with_private_ip = var.management_ip

  tags = merge(map("Name", "${var.name_prefix}f5_mgmt"), var.default_tags)

  depends_on = [aws_instance.f5_auto_demo_ltm]
}

# Security Groups
resource "aws_security_group" "f5_ext_vip_sg" {
  name        = "${var.name_prefix}f5_ext_vip_sg"
  description = "Allow inbound HTTP and HTTPS trafic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.external_sg_ports
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "f5_mgmt_sg" {
  name        = "${var.name_prefix}f5_mgmt_sg"
  description = "Allow inbound SSH and HTTPS trafic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.mgmt_sg_ports
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


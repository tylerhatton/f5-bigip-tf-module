variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_pair" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t2.large"
}

variable "management_subnet_id" {
  type = string
}

variable "external_subnet_id" {
  type = string
}

variable "internal_subnet_id" {
  type = string
}

variable "management_ip" {
  type = string
}

variable "external_ips" {
  type = list(string)
}

variable "internal_ips" {
  type = list(string)
}

variable "bigiq_server" {
  type = string
}

variable "bigiq_username" {
  type    = string
  default = "admin"
}

variable "bigiq_password" {
  type = string
}

variable "license_pool" {
  type = string
}

variable "hostname" {
  type = string
  default = "demo-f5.example.com"
}

variable "admin_password" {
  default = ""
}

variable "default_tags" {
  type = map
  default = {}
}

variable "name_prefix" {
  default = ""
}

variable "provisioned_modules" {
  type    = list(string)
  default = ["\"ltm\": \"nominal\""]
}

variable "mgmt_sg_ports" {
  default = [
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 8443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "external_sg_ports" {
  default = [
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "include_public_ip" {
  default = false
}
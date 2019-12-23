variable "AMI" {
  type = map(string)
  default = {
    us-east-1 = "ami-0ad5b2f2e46e1638b"
    us-east-2 = "ami-0ac27293a0817a4a6"
    us-west-1 = "ami-091c8ceda8668a24e"
    us-west-2 = "ami-0fc03c0127e58ec62"
  }
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "mgmt_subnet_id" {
  type = string
}

variable "external_subnet_id" {
  type = string
}

variable "internal_subnet_id" {
  type = string
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

variable "external_self_ip" {
  type = string
}

variable "internal_self_ip" {
  type = string
}

variable "management_ip" {
  type = string
}

variable "default_tags" {
  type = map
  default = {}
}

variable "name_prefix" {
  default = ""
}
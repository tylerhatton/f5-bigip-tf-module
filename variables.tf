variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the F5 BIG-IP will reside."
}

variable "key_pair" {
  type        = string
  default     = ""
  description = "Name of key pair to SSH into the F5 BIG-IP."
}

variable "instance_type" {
  type        = string
  default     = "t2.large"
  description = "Size of F5 BIG-IP's EC2 instance."
}

variable "management_subnet_id" {
  type        = string
  description = "ID of F5 BIG-IP's management subnet."
}

variable "external_subnet_id" {
  type        = string
  description = "ID of F5 BIG-IP's external subnet."
}

variable "internal_subnet_id" {
  type        = string
  description = "ID of F5 BIG-IP's internal subnet."
}

variable "management_ip" {
  type        = string
  description = "Private IP Address of F5 BIG-IP's management interface."
}

variable "external_ips" {
  type        = list(string)
  description = "List of private IP addresses used by F5 BIG-IP's external interface."
}

variable "internal_ips" {
  type        = list(string)
  description = "List of private IP addresses used by F5 BIG-IP's internal interface."
}

variable "bigiq_server" {
  type        = string
  description = "Hostname or IP address of BIG-IQ license server that will license the F5 BIG-IP."
}

variable "bigiq_username" {
  type        = string
  default     = "admin"
  description = "Username of BIG-IQ license server that will license the F5 BIG-IP."
}

variable "bigiq_password" {
  type        = string
  description = "Password of BIG-IQ license server that will license the F5 BIG-IP."
}

variable "license_pool" {
  type        = string
  description = "Name of BIG-IQ license pool that will license the F5 BIG-IP."
}

variable "hostname" {
  type        = string
  default     = "demo-f5.example.com"
  description = "Hostname of F5 BIG-IP."
}

variable "admin_password" {
  default     = ""
  description = "Admin password for F5 management console and SSH server."
}

variable "default_tags" {
  type    = map
  default = {}
}

variable "name_prefix" {
  default = ""
}

variable "provisioned_modules" {
  type        = list(string)
  default     = ["\"ltm\": \"nominal\""]
  description = "List of provisioned BIG-IP modules configured on the F5 BIG-IP."
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
  description = "List of allowed ingress ports for management interface."
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
  description = "List of allowed ingress ports for external interface."
}

variable "include_public_ip" {
  default     = false
  description = "Adds an EIP to the F5 BIG-IP management interface. true or false."
}
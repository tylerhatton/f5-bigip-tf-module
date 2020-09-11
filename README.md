# F5 LTM Terraform Template

A Terraform module to provide a licensed F5 BIG-IP device provisioned in a multi-arm configuration.

![Desktop Picture](/images/1.png)

Module Input Variables
--------------------------

- `aws_region` - AWS Region location of F5 BIG-IP.
- `vpc_id` - ID of the VPC where the F5 BIG-IP will reside.
- `key_pair` - Name of key pair to SSH into the F5 BIG-IP.
- `instance_type` - Size of F5 BIG-IP's EC2 instance.
- `management_subnet_id` - ID of F5 BIG-IP's management subnet.
- `external_subnet_id` - ID of F5 BIG-IP's external subnet.
- `internal_subnet_id` - ID of F5 BIG-IP's internal subnet.
- `management_ip` - Private IP Address of F5 BIG-IP's management interface.
- `external_ips` - List of private IP addresses used by F5 BIG-IP's external interface.
- `internal_ips` - List of private IP addresses used by F5 BIG-IP's internal interface.
- `bigiq_server` - Hostname or IP address of BIG-IQ license server that will license the F5 BIG-IP.
- `bigiq_username` - Username of BIG-IQ license server that will license the F5 BIG-IP.
- `bigiq_password` - Password of BIG-IQ license server that will license the F5 BIG-IP.
- `license_pool` - Name of BIG-IQ license pool that will license the F5 BIG-IP.
- `hostname` - Hostname of F5 BIG-IP.
- `provisioned_modules` - List of provisioned BIG-IP modules configured on the F5 BIG-IP.
- `default_tags` - Tags assigned to F5 BIG-IP instance.
- `name_prefix` - Prefix added to name tags of provisioned resources.
- `mgmt_sg_ports` - List of allowed ingress ports for management interface.
- `external_sg_ports` - List of allowed ingress ports for external interface.
- `include_public_ip` - Adds an EIP to the F5 BIG-IP management interface. true or false.

Usage
-----

```hcl
module "f5_ltm_a" {
  source               = "git@github.com:wwt/f5-ltm-tf-template/"
  aws_region           = "us-west-1"
  key_pair             = "test-key"
  name_prefix          = "${terraform.workspace}-"

  vpc_id               = "vpc-09072e62ba8e0dfc0"
  management_subnet_id = subnet-0c1c74a9b2a25646a
  external_subnet_id   = subnet-0c1c74a9b2a25646b
  internal_subnet_id   = subnet-0c1c74a9b2a25646c

  external_ips         = ["10.128.10.101"]
  internal_ips         = ["10.128.20.101"]
  management_ip        = "10.128.30.101"
  include_public_ip    = true
  
  bigiq_server         = "license.wwtlab.net"
  bigiq_username       = "admin"
  bigiq_password       = "admin"
  license_pool         = "license_server"
  provisioned_modules  = ["\"ltm\": \"nominal\"", "\"gtm\": \"nominal\""]
}
```

Outputs
=======

 - `f5_management_ip` - Public IP of F5 BIG-IP's management interface.
 - `f5_admin_password` - Password for F5 BIG-IP admin account.


Authors
=======

tyler.hatton@wwt.com
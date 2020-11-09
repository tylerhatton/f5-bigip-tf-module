# F5 LTM Terraform Template

A Terraform module to provide a licensed F5 BIG-IP device provisioned in a multi-arm configuration.

![Desktop Picture](/images/1.png)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.25 |
| aws | >= 2.68 |
| random | >= 2.3 |
| template | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| random | >= 2.3 |
| template | >= 2.1 |
| aws | >= 2.68 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vpc\_id | ID of the VPC where the F5 BIG-IP will reside. | `string` | n/a |
| key\_pair | Name of key pair to SSH into the F5 BIG-IP. | `string` | `""` |
| instance\_type | Size of F5 BIG-IP's EC2 instance. | `string` | `"t2.large"` |
| management\_subnet\_id | ID of F5 BIG-IP's management subnet. | `string` | n/a |
| external\_subnet\_id | ID of F5 BIG-IP's external subnet. | `string` | n/a |
| internal\_subnet\_id | ID of F5 BIG-IP's internal subnet. | `string` | n/a |
| management\_ip | Private IP Address of F5 BIG-IP's management interface. | `string` | n/a |
| external\_ips | List of private IP addresses used by F5 BIG-IP's external interface. | `list(string)` | n/a |
| internal\_ips | List of private IP addresses used by F5 BIG-IP's internal interface. | `list(string)` | n/a |
| bigiq\_server | Hostname or IP address of BIG-IQ license server that will license the F5 BIG-IP. | `string` | n/a |
| bigiq\_username | Username of BIG-IQ license server that will license the F5 BIG-IP. | `string` | `"admin"` |
| bigiq\_password | Password of BIG-IQ license server that will license the F5 BIG-IP. | `string` | n/a |
| license\_pool | Name of BIG-IQ license pool that will license the F5 BIG-IP. | `string` | n/a |
| hostname | Hostname of F5 BIG-IP. | `string` | `"demo-f5.example.com"` |
| admin\_password | Admin password for F5 management console and SSH server. | `string` | `""` |
| default\_tags | n/a | `map` | `{}` |
| name\_prefix | n/a | `string` | `""` |
| provisioned\_modules | List of provisioned BIG-IP modules configured on the F5 BIG-IP. | `list(string)` | <pre>[<br>  "\"ltm\": \"nominal\""<br>]</pre> |
| mgmt\_sg\_ports | List of allowed ingress ports for management interface. | `list` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": 22,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": 443,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": 8443,<br>    "protocol": "tcp"<br>  }<br>]</pre> |
| external\_sg\_ports | List of allowed ingress ports for external interface. | `list` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": 80,<br>    "protocol": "tcp"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "port": 443,<br>    "protocol": "tcp"<br>  }<br>]</pre> |
| include\_public\_ip | Adds an EIP to the F5 BIG-IP management interface. true or false. | `bool` | `false` |

## Outputs

| Name | Description |
|------|-------------|
| f5\_management\_ip | Public IP of F5 BIG-IP's management interface. |
| f5\_admin\_password | Password for F5 BIG-IP admin account. |
| f5\_mgmt\_mac\_address | MAC address for F5 management interface. Used for licensing purposes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage

```hcl
module "f5_ltm_a" {
  source               = "git@github.com:wwt/f5-ltm-tf-template/"
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

## Authors

tyler.hatton@wwt.com
output "f5_management_ip" {
  value       = var.include_public_ip == true ? aws_eip.f5_mgmt_ip[0].public_ip : ""
  description = "Public IP of F5 BIG-IP's management interface."
}

output "f5_management_private_ips" {
  value       = aws_network_interface.f5_mgmt.private_ips
  description = "Private IPs of F5 BIG-IP's management interface."
}

output "f5_internal_private_ips" {
  value       = aws_network_interface.f5_internal.private_ips
  description = "Private IPs of F5 BIG-IP's internal interface."
}

output "f5_external_private_ips" {
  value       = aws_network_interface.f5_external.private_ips
  description = "Private IPs of F5 BIG-IP's external interface."
}

output "f5_admin_password" {
  value       = var.admin_password != "" ? var.admin_password : random_password.admin_password.result
  description = "Password for F5 BIG-IP admin account."
}

output "f5_mgmt_mac_address" {
  value       = data.aws_network_interface.f5_mgmt.private_ip
  description = "MAC address for F5 management interface. Used for licensing purposes"
}
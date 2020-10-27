output "f5_management_ip" {
  value       = var.include_public_ip == true ? aws_eip.f5_mgmt_ip[0].public_ip : ""
  description = "Public IP of F5 BIG-IP's management interface."
}

output "f5_admin_password" {
  value       = var.admin_password != "" ? var.admin_password : random_password.admin_password.result
  description = "Password for F5 BIG-IP admin account."
}
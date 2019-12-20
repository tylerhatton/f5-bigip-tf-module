output "f5_mgmt_ip" {
  value       = aws_eip.f5_mgmt_ip.public_ip
  description = "The public IP address of the F5 mgmt console."
}

output "f5_admin_password" {
  value       = random_password.admin_password.result
  description = "The admin password for the F5 mgmt console."
}
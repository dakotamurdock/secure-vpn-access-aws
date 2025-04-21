output "vpn_admin_url" {
  description = "The URL for the admin portal for OpenVPN"
  value       = "https://${module.servers.vpn_public_ip}:943/admin/"
}

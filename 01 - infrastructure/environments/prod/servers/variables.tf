variable "openvpn_license" {
  description = "OpenVPN activation key"
  type        = string
  sensitive   = true
}

variable "openvpn_admin_pw" {
  description = "Admin password used to start up OpenVPN and must be changed"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "The name of the EC2 key pair to allow SSH access"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the VPN will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet where the VPN will be deployed"
  type        = string
}

variable "vpn_security_group_id" {
  description = "Security group ID for the VPN instance"
  type        = string
}

variable "private_ec2_security_group_id" {
  description = "The security group ID for EC2 instances in the private subnet"
  type        = string
}

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

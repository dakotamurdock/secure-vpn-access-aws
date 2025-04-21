output "vpn_public_ip" {
  description = "The public IP of the VPN EC2 instance"
  value       = aws_instance.vpn-ec2-instance.public_ip
}

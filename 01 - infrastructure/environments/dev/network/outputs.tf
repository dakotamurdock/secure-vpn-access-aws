output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.network.private_subnet_id
}

output "vpn_security_group_id" {
  description = "The security group ID for VPN"
  value       = module.network.vpn_security_group_id
}

output "private_ec2_security_group_id" {
  description = "The security group ID for EC2 instances in the private subnet"
  value       = module.network.private_ec2_security_group_id
}

output "s3_vpce_id" {
  description = "The VPC Endpoint ID for S3"
  value       = module.network.s3_vpce_id
}

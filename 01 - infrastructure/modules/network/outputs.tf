output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main-vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

output "vpn_security_group_id" {
  description = "The security group ID for VPN"
  value       = aws_security_group.vpn-sg.id
}

output "private_ec2_security_group_id" {
  description = "The security group ID for EC2 instances in the private subnet"
  value       = aws_security_group.private-ec2-sg.id
}

output "s3_vpce_id" {
  description = "The VPC Endpoint ID for S3"
  value       = aws_vpc_endpoint.s3-vpce.id
}

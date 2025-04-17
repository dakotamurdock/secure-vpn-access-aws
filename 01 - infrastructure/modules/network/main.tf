# Create main VPC 
resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Create a public subnet for connection to the greater internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet"
  }
}

# Create an internet gateway to connect the public subnet to the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Create a route table for the public subnet and include route to the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

# Associate subnet with corresponding route table
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a private subnet without internet access
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_az

  tags = {
    Name = "${var.environment}-private-subnet"
  }
}

# Create a route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

# Associate subnet with corresponding route table
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Create a security group for EC2 instances in the private subnet
resource "aws_security_group" "private-ec2-sg" {
  name        = "${var.environment}-test-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description = "Allow SSH for remote management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ssh-sg"
  }
}

# Create a security group for the EC2 instance hosting the OpenVPN Access Server
resource "aws_security_group" "vpn-sg" {
  name        = "${var.environment}-vpn-sg"
  description = "Allow access from VPN only"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description = "Allow SSH for remote management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN default port"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow OpenVPN WebUI"
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-vpn-sg"
  }
}

# Create a private endpoint for the S3 bucket in the VPC
resource "aws_vpc_endpoint" "s3-vpce" {
  vpc_id              = aws_vpc.main-vpc.id
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = [aws_route_table.public.id]

  tags = {
    Name = "${var.environment}-s3-vpce"
  }
}

# Route traffic from the public subnet through the private VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "public-vpce-assn" {
  route_table_id  = aws_route_table.public.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-vpce.id
}

# Route traffic from the private subnet through the private VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "private-vpce-assn" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-vpce.id
}

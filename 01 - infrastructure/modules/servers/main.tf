data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}

# EC2 instance that will run the OpenVPN Access Server
resource "aws_instance" "vpn-ec2-instance" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.vpn_security_group_id]
  key_name                    = var.ssh_key_name
  iam_instance_profile        = "EC2-S3-Full-Access"

  # This bash script runs on boot of the instance
  user_data = templatefile("${path.module}/boot.sh.tpl", {
    openvpn_license   = var.openvpn_license
    openvpn_admin_pw = var.openvpn_admin_pw
  })

  tags = {
    Name = "${var.environment}-vpn"
  }
}

# An example EC2 instance in the private subnet
resource "aws_instance" "private-ec2-instance" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.private_ec2_security_group_id]
  key_name                    = var.ssh_key_name
  iam_instance_profile        = "EC2-S3-Full-Access"

  tags = {
    Name = "${var.environment}-private-ec2-instance"
  }
}

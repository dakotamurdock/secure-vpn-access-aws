provider "aws" {
  region = "us-east-1"
}

# terraform plan -var-file="secrets.tfvars"
# terraform apply -var-file="secrets.tfvars"
# terraform destroy -var-file="secrets.tfvars"
module "servers" {
  source                            = "../../../modules/servers"
  environment                       = "prod"
  instance_type                     = "t4g.small"
  public_subnet_id                  = data.terraform_remote_state.network.outputs.public_subnet_id
  private_subnet_id                 = data.terraform_remote_state.network.outputs.private_subnet_id
  vpn_security_group_id             = data.terraform_remote_state.network.outputs.vpn_security_group_id
  private_ec2_security_group_id     = data.terraform_remote_state.network.outputs.private_ec2_security_group_id
  openvpn_license                   = var.openvpn_license
  openvpn_admin_pw                  = var.openvpn_admin_pw
  ssh_key_name                      = var.ssh_key_name
}

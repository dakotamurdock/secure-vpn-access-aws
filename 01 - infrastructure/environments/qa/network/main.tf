provider "aws" {
  region = "us-east-1"
}

module "network" {
  source              = "../../../modules/network"
  environment         = "qa"
  region              = "us-east-1"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  public_az           = "us-east-1a"
  private_az          = "us-east-1a"
}

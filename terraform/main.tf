module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  azs = var.azs

  public_subnets       = var.public_subnets
  private_app_subnets  = var.private_app_subnets
  private_db_subnets   = var.private_db_subnets

  enable_nat_gateway = var.enable_nat_gateway

  tags = var.tags
}
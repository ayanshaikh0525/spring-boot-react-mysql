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


module "rds" {
  source = "./modules/rds"

  identifier = var.identifier

  vpc_id             = module.vpc.vpc_id
  db_subnet_ids      = module.vpc.private_db_subnets

  db_name            = var.db_name
  username           = var.db_username
  password           = var.db_password

  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage

  multi_az           = var.multi_az

  tags = var.tags
}





module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id = module.vpc.vpc_id

  # 🚨 IMPORTANT: Exclude DB subnets
  subnet_ids = concat(
    module.vpc.public_subnets,
    module.vpc.private_app_subnets
  )

  private_subnet_ids = module.vpc.private_app_subnets

  tags = var.tags
}
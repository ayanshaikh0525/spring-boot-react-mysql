output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_app_subnets" {
  value = module.vpc.private_app_subnets
}

output "private_db_subnets" {
  value = module.vpc.private_db_subnets
}


############################
# EKS Outputs
############################

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_ca
  sensitive   = true
}
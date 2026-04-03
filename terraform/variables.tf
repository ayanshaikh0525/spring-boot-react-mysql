variable "vpc_cidr" {}
variable "azs" { type = list(string) }

variable "public_subnets" { type = list(string) }
variable "private_app_subnets" { type = list(string) }
variable "private_db_subnets" { type = list(string) }

variable "enable_nat_gateway" { type = bool }

variable "tags" {
  type = map(string)
}


variable "region" {}


variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}

variable "db_instance_class" {}
variable "db_allocated_storage" {}
variable "multi_az" { type = bool }

variable "identifier" {}



variable "cluster_name" {}
variable "cluster_version" {}

variable "repository_name" {}

variable "image_tag_mutability" {
  default = "MUTABLE"
}



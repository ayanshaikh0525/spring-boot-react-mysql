variable "vpc_id" {}
variable "db_subnet_ids" { type = list(string) }

variable "db_name" {}
variable "username" {}
variable "password" {
  sensitive = true
}

variable "instance_class" {}
variable "allocated_storage" {}
variable "multi_az" { type = bool }

variable "tags" {
  type = map(string)
}


variable "identifier" {}
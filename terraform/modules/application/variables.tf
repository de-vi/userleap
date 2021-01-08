variable "environment" {}

variable "public_subnet_ids" {
  type = list
}

variable "private_subnet_ids" {
  type = list
}

variable "vpc_id" {}

variable "service_name" {}

variable "ecs_instance_profile_id" {
  type = string
}

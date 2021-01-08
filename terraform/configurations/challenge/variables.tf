variable "vpc_cidr" {}

variable "public_subnets_cidr" {
  type        = list
}

variable "private_subnets_cidr" {
  type        = list
}

variable "environment" {
  description = "The environment"
}

variable "region" {
  description = "Region that the instances will be created"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}

variable "service_name" {}

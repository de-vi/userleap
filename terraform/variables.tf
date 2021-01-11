variable "vpc_cidr" {}
variable "account_id" {}
variable "elb_account_id" {}
variable "public_subnets_cidr" {
  type = list
}

variable "private_subnets_cidr" {
  type = list
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
variable "project_env" {}
variable "default_tags" {}
variable "key_pair_name" {}
variable "dns_zone_id" {}
variable "key_public_material" {
  default = ""
}
variable "alias_records" {
  default = []
}
variable "route53_record_name" {}

variable "target_groups" {
  default = []
}
variable "target_group_health_checks" {
  default = []
}
variable "target_groups_count" {
  default = 1
}
variable "listeners" {
  default = []
}
variable "listeners_count" {
  default = 1
}
variable "instance_sg_rules" {
  default = []
}
variable "lb_cidr_rules" {
  default = []
}

variable "egress_cidr_rules" {
  default = []
}

variable "access_log_bucket_name" {}
variable "ecs_image_id" {}
variable "ecs_image_version" {}
variable "contianer_port" {}
variable "host_port" {}
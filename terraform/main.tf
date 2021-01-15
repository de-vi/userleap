data "aws_acm_certificate" "app_cert" {
  domain   = var.route53_record_name
  statuses = ["ISSUED"]
  most_recent = true
}

data "terraform_remote_state" "get_pre_reqs" {
  backend = "local"
  config = {
    path = "../prerequisites/.tfstate_prerequisites"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Construct local variables for tags and resource name (these will be applied to all AWS resources)
locals {
  name                   = "${var.service_name}-${var.environment}-${var.project_env}"
  tags                   = merge(var.default_tags, { Name = local.name, environment = var.environment, service = var.service_name, project_env = var.project_env })
  availability_zones     = slice(data.aws_availability_zones.available.names, 0, 2)
  state_bucket_name      = data.terraform_remote_state.get_pre_reqs.outputs.state_bucket_name
  access_log_bucket_name = data.terraform_remote_state.get_pre_reqs.outputs.access_log_bucket_name
  lock_db_table          = data.terraform_remote_state.get_pre_reqs.outputs.dynamodb_table_name

}

# Create VPC, subnets, route tables and gateways
module "vpc" {
  source               = "github.com/de-vi/tf-module-aws-vpc?ref=v1.0.0"
  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  region               = var.region
  availability_zones   = local.availability_zones
  tags                 = local.tags
}

#Create security group for Instances(part of Autoscaling groups)
module "app_instance_sg" {
  source                       = "github.com/de-vi/tf-module-aws-sg?ref=v1.0.0"
  vpc_id                       = module.vpc.vpc_id
  name                         = format("%s-%s", local.name, "instance")
  description                  = format("%s-%s", local.name, "instance")
  tags                         = local.tags
  ingress_security_group_rules = local.ingress_instance_sg_rules
  egress_security_group_rules  = local.egress_instance_sg_rules
  egress_cidr_rules            = var.egress_instance_cidr_rules
}

#Create Launch Configuration and Autoscaling Group and attach target group to ASG
#Userdata contains ECS cluster name so that ASG instances will be registered in ECS cluster
module "app_asg" {
  source              = "github.com/de-vi/tf-module-aws-asg?ref=v1.0.0"
  name                = format("%s-%s", local.name, "instance")
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_id   = module.app_instance_sg.sg_id
  tags                = local.tags
  target_group_arn    = module.app_lb.target_group_arn
  key_public_material = var.key_public_material
  key_name            = var.key_pair_name
  user_data = templatefile("app-setup.sh.tmpl", {
    ecs_cluster_name = local.name
  })
}

#Create Security group for ALB
module "app_lb_sg" {
  source                       = "github.com/de-vi/tf-module-aws-sg?ref=v1.0.0"
  vpc_id                       = module.vpc.vpc_id
  name                         = format("%s-%s", local.name, "alb")
  description                  = format("%s-%s", local.name, "alb")
  tags                         = local.tags
  ingress_cidr_rules           = var.ingress_lb_cidr_rules
  ingress_security_group_rules = local.ingress_lb_sg_rules
  egress_security_group_rules  = local.egress_lb_sg_rules
}

#Create ALB with HTTPS listener
module "app_lb" {
  source                     = "github.com/de-vi/tf-module-aws-alb?ref=v1.0.0"
  name                       = local.name
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.public_subnet_ids
  sg_ids                     = [module.app_lb_sg.sg_id]
  target_groups              = local.target_groups
  target_group_health_checks = var.target_group_health_checks
  access_log_bucket          = local.access_log_bucket_name
  tags                       = local.tags
  ssl_cert_arn               = data.aws_acm_certificate.app_cert.arn
}

#Create Route53 A Record pointing to ALB's dns name
module "app_dns" {
  source                = "github.com/de-vi/tf-module-aws-route53?ref=v1.0.0"
  zone_id               = var.dns_zone_id
  route53_record_name   = var.route53_record_name
  target_alias_dns_name = module.app_lb.lb_dns_name
  target_alias_zone_id  = module.app_lb.lb_dns_zone_id
}

#Create ECS cluster, Task definition and Service
module "ecs" {
  depends_on           = [module.app_lb]
  source               = "github.com/de-vi/tf-module-aws-ecs?ref=v1.0.0"
  name                 = local.name
  alb_target_group_arn = module.app_lb.target_group_arn
  desired_task_count   = 2
  container_name       = var.container_name
  container_port       = var.container_port
  container_definitions = templatefile("ecs_task_def.json", {
    ecs_image_id      = var.ecs_image_id
    ecs_image_version = var.ecs_image_version
    container_name    = var.container_name
    container_port    = tonumber(var.container_port)
  })
}

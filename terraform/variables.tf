variable "region" {
  description = "Region in which you want to create infrastructure and deploy application"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDR for public subnets"
  type        = list
}

variable "private_subnets_cidr" {
  description = "CIDR for private subnets"
  type        = list
}

variable "environment" {
  description = "Name of your environment"
  type        = string
}

variable "service_name" {
  description = "Name of your service"
  type        = string
}

variable "project_env" {
  description = "system environment, for example dev, test or uat"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the keypair available in the region where the application is deployed, mutually exclusive with key_public_material"
  type        = string
}

variable "key_public_material" {
  description = "Publi key material using which a new keypair can be created, mutually exclusive with key_pair_name"
  type        = string
  default     = ""
}

variable "route53_domain_name" {
  description = "Name of the Route53 domain in which application will be hosted"
  type        = string
}

variable "route53_record_name" {
  description = "DNS name for application, must be a subdomain of route53_domain_name"
  type        = string
}

variable "target_groups" {
  description = "List of target groups to create"
  type        = list(map(string))
  default     = []
}

variable "target_group_health_checks" {
  description = "List of health checks for each target group, must contain same number of elements as target_groups"
  type        = list(map(string))
  default     = []
}

variable "listeners" {
  description = "List of listeners for ALB"
  type        = list(map(string))
  default     = []
}

variable "ingress_instance_sg_rules" {
  description = "List of inbound security group rules for instance with source security group ids"
  type        = list(map(string))
  default     = []
}

variable "egress_instance_sg_rules" {
  description = "List of outbound security group rules for instance with source security group ids"
  type        = list(map(string))
  default     = []
}

variable "ingress_lb_sg_rules" {
  description = "List of inbound security group rules for ALB with source security group ids"
  type        = list(map(string))
  default     = []
}

variable "egress_lb_sg_rules" {
  description = "List of outbound security group rules for ALB with source security group ids"
  type        = list(map(string))
  default     = []
}

variable "ingress_lb_cidr_rules" {
  description = "List of inbound security group rules for ALB with source security CID blocks"
  type        = list(map(string))
  default     = []
}

variable "egress_instance_cidr_rules" {
  description = "List of outbound security group rules for instance with source security CIDR blocks"
  type        = list(map(string))
  default     = []
}

variable "ecs_image_id" {
  description = "ECR image name"
  type        = string
}

variable "ecs_image_version" {
  description = "ECR image version"
  type        = string
}

variable "container_name" {
  description = "Container name for task definiton"
  type        = string
}

variable "container_port" {
  description = "Container port where application is running"
  type        = string
}

variable "region" {
  description = "Region in which you want to create infrastructure and deploy application"
  type        = string
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

variable "route53_domain_name" {
  description = "Name of the Route53 domain in which application will be hosted"
  type        = string
}

variable "route53_record_name" {
  description = "DNS name for application, must be a subdomain of route53_domain_name"
  type        = string
}

variable "applications" {
  description = "List of application prefixes to add in access log s3 bucket policy, must be a comma separated string. For example"
  type        = string

}

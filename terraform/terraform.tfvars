environment          = "challenge"
service_name         = "woogie-bucket"
project_env          = "dev"
region               = "us-west-1"
account_id           = "262667049843"
elb_account_id       = "027434742980"
availability_zones   = ["us-west-1b", "us-west-1c"]
vpc_cidr             = "10.0.0.0/16"
private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
default_tags = {
  createdBy = "devi"
}
key_pair_name          = "devi-us-west-1"
dns_zone_id            = "Z03943581T5142H50GMOB"
route53_record_name    = "app.userleap.de-vi.me"
access_log_bucket_name = "woogie-bucket-challenge-dev-access-log-bucket"
target_groups_count    = 1
listeners_count        = 1

target_group_health_checks = [{
  healthy_threshold   = 2
  unhealthy_threshold = 10
  interval            = 30
  path                = "/"
  matcher             = "200"
  protocol            = "HTTP"
  timeout             = 5
}]

lb_cidr_rules = [
  {
    desc        = "Allow HTTPS access to load balancer from everywhere"
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = "0.0.0.0/0"
  }
]
egress_cidr_rules = [
  {
    desc        = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
]




environment          = "challenge"
service_name         = "woogie-bucket"
project_env          = "dev"
vpc_cidr             = "10.0.0.0/16"
private_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
container_name       = "woogie"
container_port       = 5000

target_group_health_checks = [{
  healthy_threshold   = 2
  unhealthy_threshold = 10
  interval            = 30
  path                = "/"
  matcher             = "200"
  protocol            = "HTTP"
  timeout             = 5
}]

ingress_lb_cidr_rules = [
  {
    desc        = "Allow HTTPS access to load balancer from everywhere"
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    desc        = "Allow HTTP access to load balancer from everywhere"
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = "0.0.0.0/0"
  }
]
egress_instance_cidr_rules = [
  {
    desc        = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
]

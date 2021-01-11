locals {
  listeners = [{
    port         = 443,
    protocol     = "HTTPS",
    ssl_cert_arn = module.app_cert.acm_cert_arn
  }]
  target_groups = [{
    name        = local.name,
    port        = 5000,
    protocol    = "HTTP",
    target_type = "instance"
  }]
  instance_sg_rules = [{
    desc                     = "Allow flask app access from load balancer",
    from_port                = 5000,
    to_port                  = 5000,
    protocol                 = "tcp",
    source_security_group_id = module.app_lb_sg.sg_id
  }]
}
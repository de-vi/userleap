locals {
  target_groups = [{
    name     = local.name,
    port     = 5000,
    protocol = "HTTP"
  }]

  ingress_instance_sg_rules = [{
    desc                     = "Allow access to ephemeral ports for dynamic ports mapping",
    from_port                = 32768,
    to_port                  = 65535,
    protocol                 = "tcp",
    source_security_group_id = module.app_lb_sg.sg_id
  }]

  egress_instance_sg_rules = [{
    desc                     = "Allow access to ephemeral ports for dynamic ports mapping",
    from_port                = 32768,
    to_port                  = 65535,
    protocol                 = "tcp",
    source_security_group_id = module.app_lb_sg.sg_id
  }]

  ingress_lb_sg_rules = [{
    desc                     = "Allow access to ephemeral ports for dynamic ports mapping",
    from_port                = 32768,
    to_port                  = 65535,
    protocol                 = "tcp",
    source_security_group_id = module.app_instance_sg.sg_id
  }]

  egress_lb_sg_rules = [{
    desc                     = "Allow access to ephemeral ports for dynamic ports mapping",
    from_port                = 32768,
    to_port                  = 65535,
    protocol                 = "tcp",
    source_security_group_id = module.app_instance_sg.sg_id
  }]
}

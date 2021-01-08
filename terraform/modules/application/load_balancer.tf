
resource "aws_alb_target_group" "app_alb_target_group" {
  name_prefix = "chall-"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
 
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 10
  }

  tags = {
    Name        = "${var.environment}-${var.service_name}-target-group"
    Environment = var.environment
    Application = var.service_name
  }
}

resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = aws_lb_listener.http_alb_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

}

/* security group for ALB */
resource "aws_security_group" "app_inbound_sg" {
  name        = "${var.environment}-app-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-inbound-sg"
  }
}

resource "aws_alb" "app-alb" {
  name            = "${var.environment}-app-alb"
  subnets         = flatten(var.public_subnet_ids)
  security_groups = [aws_security_group.app_inbound_sg.id]

  idle_timeout = 10

  tags = {
    Name        = "${var.environment}-app-alb"
    Environment = var.environment
  }
}

// Non SSL traffic (skipping SSL)
resource "aws_lb_listener" "http_alb_listener" {
  load_balancer_arn = aws_alb.app-alb.arn
  certificate_arn = aws_acm_certificate.app_cert.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found."
      status_code  = "404"
    }
  }
}

resource "aws_acm_certificate" "app_cert" {
  domain_name               = "app.userleap.de-vi.me"
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [aws_route53_record.app_dns_record.fqdn]
}

resource "aws_route53_record" "app_dns_record" {
  zone_id = "Z03943581T5142H50GMOB"
  name    = "app.userleap.de-vi.me"
  type    = "A"

  alias {
    name                   = aws_alb.app-alb.dns_name
    zone_id                = aws_alb.app-alb.zone_id
    evaluate_target_health = true
  }
}

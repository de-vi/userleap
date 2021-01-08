
data "aws_ami" "db_labs_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "app_server_lc" {
  name_prefix                   =  "app-server-lc-"
#  image_id                      =  data.aws_ami.db_labs_ami.image_id
  image_id                      = "ami-074b21921829825e1"
  instance_type                 = "t3.micro"
  key_name                      = "devi-us-west-1"
  security_groups               = [aws_security_group.app_server_ssh.id]
  user_data                     = file("${path.module}/app-setup.sh")
  associate_public_ip_address   = false
  iam_instance_profile = var.ecs_instance_profile_id
  
}

resource "aws_autoscaling_group" "app_server_asg" {
  name                 = "app-server-asg"
  launch_configuration = aws_launch_configuration.app_server_lc.name
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = var.private_subnet_ids
  tag {
    key   = "Environment"
    value = var.environment
    propagate_at_launch = true
  }
  tag {
    key   = "Name"
    value = var.service_name
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_attachment" "app_tg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_server_asg.id
  alb_target_group_arn = aws_alb_target_group.app_alb_target_group.arn
}

resource "aws_security_group" "app_server_ssh" {
  name        = "${var.environment}-app-server-ssh-sg"
  description = "Allow SSH from Home"
  vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app_inbound_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-server-ssh-sg"
  }
}


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


resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.db_labs_ami.image_id
  instance_type               = "t3.micro"

#   key_name                      = "challenge-key"
  associate_public_ip_address   = false
  subnet_id                     = var.private_subnet_ids[0]

  vpc_security_group_ids = [aws_security_group.app_server_ssh.id]
  
  user_data = file("${path.module}/app-setup.sh")

  tags = {
    Environment = var.environment
    Name        = var.service_name
  }

  lifecycle {
    ignore_changes = [ ami ]
  }
}

resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_alb_target_group.app_alb_target_group.arn
  target_id        = aws_instance.app_server.id
  port             = 5000
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
    cidr_blocks     = ["10.0.20.0/24"]
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

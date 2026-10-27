resource "aws_lb" "app_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Allow public HTTP traffic to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-sg"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.name}-alb-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    protocol            = var.target_protocol
    matcher             = var.health_check_matcher
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name = "${var.name}-alb-tg"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
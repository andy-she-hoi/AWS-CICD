resource "aws_lb" "alb" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets_ids

  tags = {
    Environment = "production"
  }
}

resource "aws_alb_target_group" "tg" {
  name        = "${var.app_name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    interval            = "60"
    timeout             = "30"
    matcher             = "200-499"
    path                = var.health_check_path
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-tg"
    Environment = var.environment
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_tls_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.tg.id
    type             = "forward"
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_hosted_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_target_group_arn" {
  value = aws_alb_target_group.tg.arn
}
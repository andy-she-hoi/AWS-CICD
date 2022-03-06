resource "aws_security_group" "ecs_sg" {
  name   = "${var.app_name}-${var.environment}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = "0"
    to_port   = "65535"
    protocol  = "tcp"

    security_groups = [
      var.alb_security_group_id
    ]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-ecs-sg"
    Environment = var.environment
  }
}
resource "aws_ecs_cluster" "cluster" {
    name = "${var.app_name}-${var.environment}-cluster"
    tags = {
        Name        = "${var.app_name}-${var.environment}-cluster"
        Environment = var.environment
    }
}

resource "aws_ecs_service" "service" {
  name                               = "${var.app_name}-${var.environment}-service"
  cluster                            = aws_ecs_cluster.cluster.id
  task_definition                    = aws_ecs_task_definition.task_definition.arn
  desired_count                      = var.ecs_desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = var.subnets_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.app_name}-${var.environment}-container"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "ECS" # Rolling update
  }
}

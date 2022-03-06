resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.app_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
  cpu                      = var.container_cpu * 1024
  memory                   = var.container_memory * 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "${var.app_name}-${var.environment}-container"
      image = var.container_image
      
      "portMappings":[
        {
          "containerPort": var.container_port
          "protocol": "tcp"
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.app_name}-${var.environment}-task"
    Environment = var.environment
  }
}
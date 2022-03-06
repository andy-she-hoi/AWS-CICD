variable "app_name" {
  description = "the name of your app"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "vpc_id" {
  description = "vpc_id"
}

variable "subnets_ids" {
  description = "subnets_ids"
}

variable "container_cpu" {
  description = "container_cpu"
}

variable "container_memory" {
  description = "container_memory"
}

variable "container_image" {
  description = "container_image"
}

variable "container_port" {
  description = "container_port"
}

variable "alb_security_group_id" {
  description = "ID of the alb security group"
}

variable "alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "ecs_desired_count" {
  description = "Number of services running in parallel"
}

variable "assign_public_ip" {
  description = "assign_public_ip"
}

variable "avg_cpu_target" {
  description = "avg_cpu_target for auto scaling"
}

variable "avg_memory_target" {
  description = "avg_memory_target for auto scaling"
}
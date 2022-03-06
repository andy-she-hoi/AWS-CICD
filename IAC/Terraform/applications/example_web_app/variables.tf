variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "subdomain_name" {
  type        = string
  description = "The subdomain name for the website."
}

variable "hosted_zone_name" {
  type        = string
  description = "hosted_zone_name"
}

variable "app_name" {
  type        = string
  description = "app_name"
}

variable "environment" {
  type        = string
  description = "environment"
}

variable "cidr_block" {
  description = "cidr_block"
}

variable "public_subnets" {
  description = "public_subnets"
}

variable "private_subnets" {
  description = "private_subnets"
}

variable "availability_zones" {
  description = "availability_zones"
}

variable "nat_numbers" {
  description = "nat_numbers"
  default = 1
}

variable "health_check_path" {
  description = "health_check_path"
}

variable "alb_domain" {
  description = "alb_domain"
}

variable "container_cpu" {
  description = "container_cpu"
}

variable "container_memory" {
  description = "container_memory"
}

variable "image_tag" {
  description = "image_tag"
}

variable "container_port" {
  description = "container_port"
}

variable "ecs_desired_count" {
  description = "ecs_desired_count"
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
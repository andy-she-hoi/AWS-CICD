variable "app_name" {
  description = "the name of your app"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "public_subnets_ids" {
  description = "public_subnets_ids"
}

variable "vpc_id" {
  description = "vpc_id"
}

variable "health_check_path" {
  description = "health_check_path"
}

variable "alb_tls_cert_arn" {
  description = "alb_tls_cert_arn"
}
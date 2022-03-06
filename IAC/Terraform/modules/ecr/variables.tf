variable "repository_name" {
  type        = string
  description = "The repositary name in the ECR."
}

variable "image_mutability" {
  type        = string
  description = "image mutability"
  default     = "MUTABLE"
}

variable "image_scanning" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"
  default     = false
}
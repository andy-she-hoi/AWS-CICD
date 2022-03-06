resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.image_mutability

  image_scanning_configuration {
    scan_on_push = var.image_scanning
  }
}

output "repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}
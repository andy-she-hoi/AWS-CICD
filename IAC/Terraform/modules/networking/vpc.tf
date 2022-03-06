resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.app_name}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment}-igw"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
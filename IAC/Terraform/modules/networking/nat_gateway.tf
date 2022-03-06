resource "aws_eip" "nat" {
    count = length(compact(var.private_subnets)) >= 1 ? var.nat_numbers : 0
    
    vpc           = true
    depends_on    = [aws_internet_gateway.igw]

    tags = {
        Name        = "${var.app_name}-eip-${var.environment}-${format("%03d", count.index+1)}"
        Environment = var.environment
    }
}

resource "aws_nat_gateway" "nat" {
    count         = length(compact(var.private_subnets)) >= 1 ? var.nat_numbers : 0

    allocation_id = element(aws_eip.nat.*.id, count.index)
    subnet_id     = element(aws_subnet.public.*.id, count.index)
    depends_on    = [aws_internet_gateway.igw]

    tags = {
        Name        = "${var.app_name}-nat-${var.environment}-${format("%03d", count.index+1)}"
        Environment = var.environment
    }
}

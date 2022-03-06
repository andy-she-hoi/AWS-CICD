# Public subnets
resource "aws_subnet" "public" {
  count                   = length(compact(var.public_subnets))

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  count  = length(compact(var.public_subnets)) >= 1 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.app_name}-route-table-public"
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  count                  = length(compact(var.public_subnets)) >= 1 ? 1 : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(compact(var.public_subnets))

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(compact(var.private_subnets))

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${var.environment}-${format("%03d", count.index+1)}"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  count = length(compact(var.private_subnets)) >= 1 ? 1 : 0
  
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.app_name}-route-table-private"
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets)) >= 1 ? 1 : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}
 
resource "aws_route_table_association" "private" {
  count          = length(compact(var.private_subnets))

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}

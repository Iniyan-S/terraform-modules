resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "ecs_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.cluster_name}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "ecs_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name = "${var.cluster_name}-route-table"
  }
}

resource "aws_route_table_association" "ecs_route_table_assoc" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.ecs_subnet.*.id, count.index)
  route_table_id = aws_route_table.ecs_route_table.id
}
/*==================================================
      AWS VPC Module: Main Configuration
===================================================*/

# ------- VPC Creation -------
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  instance_tenancy               = "default"
  enable_dns_hostnames           = true
  enable_dns_support             = true
  # enable_network_address_usage_metrics = true
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# ------- Internet Gateway -------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# ------- Elastic IP -------
resource "aws_eip" "main" {
  vpc = true
  tags = {
    Name        = "${var.environment}-eip"
    Environment = var.environment
  }
}

# ------- NAT Gateway -------
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name        = "${var.environment}-ngw"
    Environment = var.environment
  }
}

# ------- Public Subnets -------
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_prefix, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# ------- Private Subnets -------
resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_prefix, count.index + 101)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# ------- Public Route Table -------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# ------- Private Route Table -------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

# ------- Route Table Associations -------
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ------- Data for Availability Zones -------
data "aws_availability_zones" "available" {
  state = "available"
}






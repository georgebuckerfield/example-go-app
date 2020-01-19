provider "aws" {
  region  = "eu-west-2"
}

######## VPC
resource "aws_vpc" "primary" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "primary"
  }
}

######## Public subnets
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.primary.id

  count = length(var.vpc_public_subnet_ranges)
  cidr_block = var.vpc_public_subnet_ranges[count.index]
  availability_zone = var.vpc_availability_zones[count.index]

  tags = {
    Name = "public-subnet-${var.vpc_availability_zones[count.index]}"
  }
}


######## Private subnets
resource "aws_subnet" "private_subnets" {

  vpc_id            = aws_vpc.primary.id
  count             = length(var.vpc_private_subnet_ranges)
  cidr_block        = var.vpc_private_subnet_ranges[count.index]
  availability_zone = var.vpc_availability_zones[count.index]

  tags = {
    Name = "private-subnet-${var.vpc_availability_zones[count.index]}"
  }
}

######## Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary.id
}

######## NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnets[0].id
  depends_on = [aws_internet_gateway.igw]
}

######## Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
resource "aws_route_table_association" "public" {
  count          = length(var.vpc_private_subnet_ranges)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

######## Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "private" {
  count          = length(var.vpc_private_subnet_ranges)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

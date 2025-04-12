terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Fetch available availability zones
data "aws_availability_zones" "available" {}

# Define tags locally
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

# Create a new VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.default_tags, { Name = "${var.prefix}-vpc" })
}

# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.default_tags, { Name = "${var.prefix}-public-subnet-${count.index}" })
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.default_tags, { Name = "${var.prefix}-private-subnet-${count.index}" })
}

# Create an Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count = var.env == "nonprod" ? 1 : 0
}

# Create a NAT Gateway in the Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  count         = var.env == "nonprod" ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id  # Place it in the first public subnet

  tags = {
    Name = "nonprod-nat-gw"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.default_tags, { Name = "${var.prefix}-igw" })
}

# Route Table for Public Subnets
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.default_tags, { Name = "${var.prefix}-route-public" })
}

# Create a Private Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  count  = var.env == "nonprod" ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags, { Name = "${var.prefix}-route-private" })
}

# Add a Route for NAT Gateway in Private Route Table
resource "aws_route" "private_nat_route" {
  count                  = var.env == "nonprod" ? 1 : 0
  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}


# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = var.env == "nonprod" ? length(aws_subnet.private_subnet) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[0].id
}

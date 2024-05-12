# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "${var.vpc_name}_VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_IGW"
  }
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.vpc_name}_PublicSubnet1"
  }
}

# Create a second Public Subnet
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.vpc_name}_PublicSubnet2"
  }
}

# Create a Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.vpc_name}_PrivateSubnet1"
  }
}

# Create a second Private Subnet
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.vpc_name}_PrivateSubnet2"
  }
}

# Create a Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}_PublicRouteTable"
  }
}

# Associate the Public Route Table with the Public Subnet
resource "aws_route_table_association" "blog_public_1_rta" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "blog_public_2_rta" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

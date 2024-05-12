output "vpc_id" {
  value = aws_vpc.vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
  description = "The ID of the Public Subnet"
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
  description = "The ID of the Public Subnet"
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
  description = "The ID of the first Private Subnet"
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
  description = "The ID of the second Private Subnet"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway"
}

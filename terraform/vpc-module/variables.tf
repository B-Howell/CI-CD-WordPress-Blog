# VPC Variables
variable "vpc_cidr" {
  description = "The CIDR range of the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

# Public Subnet Variables
variable "public_subnet_1_cidr" {
  description = "The CIDR range of the 1st Public Subnet"
  type        = string
}

# Public Subnet Variables
variable "public_subnet_2_cidr" {
  description = "The CIDR range of the 2nd Public Subnet"
  type        = string
}

# Private Subnet 1 Variables
variable "private_subnet_1_cidr" {
  description = "The CIDR range of the 1st Private Subnet"
  type        = string
}

#Private Subnet 2 Variables
variable "private_subnet_2_cidr" {
  description = "The CIDR range of the 2nd Private Subnet"
  type        = string
}
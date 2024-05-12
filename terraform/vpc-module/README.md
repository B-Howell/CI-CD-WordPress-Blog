# Terraform Network Module for AWS

## Overview
This module sets up a basic network infrastructure in AWS. It creates a VPC, an Internet Gateway, one public subnet, and two private subnets.

## Inputs

| Name                  | Description                                     | Type   | Default | Required | 
|-----------------------|-------------------------------------------------|--------|:-------:|:--------:|
| vpc_cidr              | The CIDR range of the VPC                       | string | n/a     | Yes      |
| vpc_name              | The name of the VPC                             | string | n/a     | Yes      |
| public_subnet_cidr    | The CIDR range of the Public Subnet             | string | n/a     | Yes      |
| public_subnet_az      | The Availability Zone of the Public Subnet      | string | n/a     | Yes      |
| private_subnet_1_cidr | The CIDR range of the 1st Private Subnet        | string | n/a     | Yes      |
| private_subnet_1_az   | The Availability Zone of the 1st Private Subnet | string | n/a     | Yes      |
| private_subnet_2_cidr | The CIDR range of the 2nd Private Subnet        | string | n/a     | Yes      |
| private_subnet_2_az   | The Availability Zone of the Public Subnet      | string | n/a     | Yes      |

## Outputs

| Name                | Description                         |
|:--------------------|:------------------------------------|
| vpc_id              | The ID of the VPC                   |
| public_subnet_id    | The ID of the Public Subnet         |
| private_subnet_1_id | The ID of the first Private Subnet  |
| private_subnet_2_id | The ID of the second Private Subnet |
| internet_gateway_id | The ID of the Internet Gateway      |

## Requirements
- Terraform 0.12+
- AWS Provider

## Note

You will have to configure Security Groups still. They are not included ias part of this module.

## Usage
To use this module in your Terraform configuration, include the following HCL:

module "vpc_module" {
  source = "./vpc-module"

  vpc_cidr              = ""
  vpc_name              = ""
  public_subnet_cidr    = ""
  public_subnet_az      = ""
  private_subnet_1_cidr = ""
  private_subnet_1_az   = ""
  private_subnet_2_cidr = ""
  private_subnet_2_az   = ""
}

You will determine the variables above to your specific configuration.

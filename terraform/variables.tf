variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "terraform"
}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "public_key" {
  description = "The public SSH key to be used for the EC2 instance"
  type        = string
}

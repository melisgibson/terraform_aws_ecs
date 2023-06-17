# --- networking/module/variables.tf ---
variable "environment" {}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}
variable "vpc_name"{
    description = "vpc name tags"
}
variable "gw_name"{
    description = "internet gateway name"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_name_prefix" {
    description = "public subnet name"
}

variable "private_subnet_name_prefix" {
    description = "private subnet name"
}

variable "nat_eip_name" {
  description = "Name of nat elastic ip"
}

variable "nat_gateway_name" {
    description = "Name nat gateway"
}

variable "public_rt_name" {
  description = "public route table name"
}

variable "private_rt_name" {
  description = "private route table name"
}

variable "sg_name" {
    description = "Security group name"
}

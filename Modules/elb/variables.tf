#---elb/module/variables.tf---
variable "alb_name" {
  description = "Name of the ALB"
}

variable "public_subnets" {
  description = "List of public subnet IDs to place the ALB in"
}

variable "alb_sg" {
  description = "List of security group IDs to attach to the ALB"
}

variable "access_log_bucket" {
  description = "Name of the S3 bucket to store access logs"
}

variable "access_log_path" {
  description = "Path in bucket to where logs will be stored"
}

variable "environment" {
  description = "Environment where the resources will be created (e.g. dev, prod)"
}

variable "target_group_arn" {
  
}

variable "listener_port" {
type = number
description = "The port to listen on for the application load balancer listener."
}

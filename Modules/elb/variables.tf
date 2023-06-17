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

variable "environment" {
  description = "Environment where the resources will be created (e.g. dev, prod)"
}


variable "listener_port" {
type = number
description = "The port to listen on for the application load balancer listener."
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
}

variable "tg_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_type" {
  description = "Type of targets for the target group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the target group will be created"
  type        = string
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks required to consider a target healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks required to consider a target unhealthy"
  type        = number
}

variable "health_check_interval" {
  description = "Interval between health checks (in seconds)"
  type        = number
}

variable "health_check_path" {
  description = "Path of the health check endpoint"
  type        = string
}

variable "health_check_timeout" {
  description = "Timeout for the health check (in seconds)"
  type        = number
}
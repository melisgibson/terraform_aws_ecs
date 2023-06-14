# ---ec2/module/variables.tf---
variable "ami_owner" {
  type        = string
  description = "The AWS account ID of the owner of the AMI."
}

variable "ami_name" {
  type        = string
  description = "The name of the AMI to use."
}

variable "launch_template_name" {
  type        = string
  description = "The name of the launch template."
}

variable "environment" {
  type        = string
  description = "The environment for the resources."
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type to use."
}

variable "iam_instance_profile" {
  type       = string
  description = "Instance profile role."
}
variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair to use."
}

variable "security_group_lt" {
  type        = string
  description = "The ID of the security group to use for the launch template."
}

variable "instance_name" {
  description = "Name tag for instances."
}

variable "user_data" {
  type        = string
  description = "The user data script to run on the instances."
}

variable "asg_name" {
  type        = string
  description = "The name of the auto scaling group."
}

variable "min_size" {
  type        = number
  description = "The minimum size of the auto scaling group."
}

variable "desired_capacity" {
  type        = number
  description = "The desired capacity of the auto scaling group."
}

variable "max_size" {
  type        = number
  description = "The maximum size of the auto scaling group."
}

variable "service_linked_role_arn" {
  type        = string
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services."
}

variable "subnet_ids" {
  description = "The IDs of the subnets in which to launch the instances."
}
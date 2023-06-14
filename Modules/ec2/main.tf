# ---ec2/module/main.tf---
data "aws_ami" "ami" {
  most_recent = true
  owners = [var.ami_owner]

  filter {
    name   = "name"
    values = ["${var.ami_name}*"]
  }
}

resource "aws_launch_template" "launch_template" {
  name = var.launch_template_name
  tags = {
    Name = var.launch_template_name
    Environment = var.environment
  }
  image_id = data.aws_ami.ami.id
  iam_instance_profile {
    arn = var.iam_instance_profile
  }
  instance_type = var.instance_type
  key_name = var.key_name
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }  
  monitoring {
    enabled = true
  }
  network_interfaces {
    security_groups             = [var.security_group_lt]
  }
  tag_specifications {
    tags = {
      name = var.instance_name
    }

    resource_type = "instance"
  }

  user_data =  var.user_data
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = var.asg_name
  health_check_type = "EC2"
  launch_template      {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  max_instance_lifetime   = 604800
  default_cooldown  = 300
  metrics_granularity     = "1Minute"
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  service_linked_role_arn = var.service_linked_role_arn
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key = "Name"
    value = var.asg_name
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = var.environment
    propagate_at_launch = true
  }
}
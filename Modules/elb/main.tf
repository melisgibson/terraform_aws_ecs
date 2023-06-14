# ---elb/main.tf/module---
# Create alb
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets = var.public_subnets
  security_groups = [var.alb_sg]
  desync_mitigation_mode           = "defensive"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 300
  ip_address_type                  = "ipv4"

  access_logs {
    bucket  = var.access_log_bucket
    prefix  = var.access_log_path
    enabled = true
    
  }

  tags = {
    Name = var.alb_name
    Environment = var.environment
  }
}

# Create a listener for the target group
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  tags = {
    Name        = "${var.alb_name}-listener"
    Environment = var.environment
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port       = "443"
      protocol   = "HTTPS"
      status_code = "HTTP_301"
    }
}
}
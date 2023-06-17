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

  tags = {
    Name = var.alb_name
    Environment = var.environment
  }
}

# Create a listener for the target group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  tags = {
    Name        = "${var.alb_name}-listener"
    Environment = var.environment
  }
}


# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     redirect {
#       port       = "443"
#       protocol   = "HTTPS"
#       status_code = "HTTP_301"
#     }
# }
# }

# Create a target group
resource "aws_lb_target_group" "tg" {
  name             = var.tg_name
  port             = var.tg_port
  protocol         = "HTTP"
  target_type      = var.target_type
  vpc_id           = var.vpc_id
  load_balancing_algorithm_type = "round_robin"
  health_check {
    enabled = true
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.health_check_interval
    matcher = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
  }
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
  tags = {
    Environment = var.environment
    Name        = var.tg_name
  }
}
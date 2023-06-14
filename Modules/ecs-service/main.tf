# ---ecs-service/module/main.tf---

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.task_family
  container_definitions    = var.container_definitions
  execution_role_arn       = var.execution_role_arn
  task_role_arn = var.task_role_arn
  network_mode = var.network_mode
  requires_compatibilities = [ "EC2" ]
  dynamic "volume" {
    for_each = var.task_definition_volumes
    content {
      name = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = [volume.value.docker_volume_configuration]
        content {
          scope  = docker_volume_configuration.value.scope
          driver = docker_volume_configuration.value.driver
        }
      }
    }
  }
}


resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  deployment_maximum_percent         = var.deployment_max
  deployment_minimum_healthy_percent = var.deployment_min
  desired_count   = var.desired_count
  launch_type                        = "EC2"
  deployment_controller {
    type = "ECS"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  deployment_circuit_breaker {
    enable = var.enable_deployment_circuit_breaker
    rollback = var.enable_rollback
  }
  placement_constraints {
    type       = var.placement_constraint_type
    expression = var.placement_constraint_expression
  }
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  enable_execute_command             = var.enable_execute_command
  health_check_grace_period_seconds  = var.health_check_grace_period 
  iam_role                           = var.iam_role
}

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

# Add rule to listener
resource "aws_lb_listener_rule" "host_header_rule" {
  count = var.create_listener_host_header_rule ? 1 : 0
  listener_arn  = var.alb_listener_arn
  priority      = var.priority_host_header

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = var.host_header_value
    }
  }
}

resource "aws_lb_listener_rule" "path_pattern_rule" {
  count = var.create_listener_path_pattern_rule ? 1 : 0
  listener_arn  = var.alb_listener_arn
  priority      = var.priority_path_pattern

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern_value]
    }
  }
}
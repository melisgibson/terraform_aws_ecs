# ---ecs-service/module/main.tf---

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.task_family
  container_definitions    = var.container_definitions
  execution_role_arn       = var.execution_role_arn
  task_role_arn = var.task_role_arn
  network_mode = var.network_mode
  requires_compatibilities = [ "EC2" ]
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
    target_group_arn = var.target_group_arn
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
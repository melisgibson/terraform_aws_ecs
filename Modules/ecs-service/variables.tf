# ---ecs-service/module/variables.tf---

variable "ecs_cluster_id" {}

variable "task_family" {
  type = string
}

variable "container_definitions" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}


variable "service_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "deployment_max" {
  
}

variable "deployment_min" {
  
}
variable "enable_deployment_circuit_breaker" {
  type    = bool

}

variable "enable_rollback" {
  type    = bool

}

variable "placement_constraint_type" {
  type    = string

}

variable "placement_constraint_expression" {
  type    = string
}

variable "enable_ecs_managed_tags" {
  type    = bool

}

variable "propagate_tags" {
  type    = string

}

variable "enable_execute_command" {
  type    = bool

}

variable "health_check_grace_period" {
  type    = number

}

variable "iam_role" {
  type = string
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "environment" {
  description = "Environment where the resources will be created (e.g. dev, prod)"
}

variable "tg_name" {
  description = "Name of the target group"
}

variable "tg_port" {
  description = "Port that the containers are listening on"
}

variable "target_type" {
  
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks before considering the target healthy"
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering the target unhealthy"
}

variable "health_check_interval" {
  description = "Time in seconds between health checks"
}
variable "health_check_path" {
type = string
description = "The URL path to use when checking the health of the instances."
}

variable "health_check_timeout" {
type = number
description = "The amount of time (in seconds) to wait for a response from the instance before considering it a failed health check."
}

variable "alb_listener_arn" {
  
}

variable "create_listener_host_header_rule" {
  description = "Flag to determine whether to create the listener rule with host header condition"
  type        = bool
}

variable "create_listener_path_pattern_rule" {
  description = "Flag to determine whether to create the listener rule with path pattern condition"
  type        = bool
}

variable "priority_host_header" {
  description = "Priority for the listener rule with host header condition"
  type        = number
}

variable "priority_path_pattern" {
  description = "Priority for the listener rule with path pattern condition"
  type        = number
}

variable "host_header_value" {
  description = "Value for the host header condition"
  type        = list(string)
}

variable "path_pattern_value" {
  description = "Value for the path pattern condition"
  type        = string
}

variable "task_definition_volumes" {
  type = list(object({
    name                       = string
    docker_volume_configuration = object({
      scope  = string
      driver = string
    })
  }))
  default = []
}

variable "network_mode" {
  
}
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

variable "network_mode" {
  
}

variable "target_group_arn" {

}
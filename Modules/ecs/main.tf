# ---ecs/module/main.tf---

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  tags = {
    Terraform   = "true"
    Environment = var.environment

  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

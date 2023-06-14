# --- prod/us-east-2/main.tf ---
provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "Global" {
  backend = "s3"

  config = {
    bucket = "terraform-state"
    key    = "Deployments/global/global.tfstate"
    region = "us-east-1"
  }
}

module "networking" {
  source                     = "../../Modules/networking"
  environment                = "prod"
  vpc_cidr                   = "10.19.0.0/16"
  vpc_name                   = "prod-us-east-1-vpc"
  gw_name                    = "prod-us-east-1-gw"
  nat_eip_name               = "prod-us-east-1-nat-eip"
  nat_gateway_name           = "prod-us-east-1-nat-gw"
  public_subnet_cidr_blocks  = ["10.19.1.0/24", "10.19.2.0/24"]
  private_subnet_cidr_blocks = ["10.19.3.0/24", "10.19.4.0/24"]
  availability_zones         = ["us-east-1a", "us-east-1b"]
  public_subnet_name_prefix  = "public-subnet-prod"
  private_subnet_name_prefix = "private-subnet-prod"
  public_rt_name             = "public-rt-prod"
  private_rt_name            = "private-rt-prod"
  sg_name                    = "prod-us-east-1-sg"
  lb_sg_name                 = "prod-us-east-1-lb-sg"
  nacl_name                  = "prod-us-east-1-nacl"
}

module "ec2" {
  source                  = "../../Modules/ec2"
  ami_owner               = "137112412989"
  ami_name                = "al2023-ami-2023.0.20230614.0-kernel-6.1-x86_64"
  launch_template_name    = "prod-ecs-us-east-1-lt"
  environment             = "prod"
  instance_type           = "t2.micro"
  iam_instance_profile    = "arn:aws:iam::027427181034:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  key_name                = "MyKey"
  security_group_lt       = module.networking.sg_id
  instance_name           = "prod-ecs-us-east-1-node"
  user_data               = filebase64("user_data.sh")
  asg_name                = "prod-ecs-us-east-1-asg"
  min_size                = 1
  desired_capacity        = 2
  max_size                = 5
  service_linked_role_arn = "arn:aws:iam::027427181034:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  subnet_ids              = module.networking.private_subnet_ids
}

# module "ecs" {
#   source         = "../../Modules/ecs"
#   environment    = "prod"
#   cluster_name   = "prod-us-east-1-ecs"
# }

# module "alb-deckviewer" {
#   source              = "../../Modules/elb"
#   environment         = "prod"
#   alb_name            = "prod-use1-alb"
#   target_group_arn    = module.ecs-service.target_group_arn
#   public_subnets      = module.networking.public_subnet_ids
#   alb_sg              = module.networking.lb_sg_id
#   listener_port       = 443
# #   ssl_certificate_arn = ""
#   access_log_bucket   = "us-east-1-elb-access-logs"
#   access_log_path     = "prod-use1-alb"
# }


# module "ecs-service" {
#   source                            = "../../Modules/ecs-service"
#   ecs_cluster_id                    = module.ecs.ecs_cluster_id
#   task_family                       = "test-prod"
#   container_definitions             = file("${path.module}/ecs-cd.json")
#   task_definition_volumes           = []
#   service_name                      = "test-prod"
#   desired_count                     = 2
#   deployment_max                    = 200
#   deployment_min                    = 100
#   container_name                    = "test-prod"
#   container_port                    = 4000
#   enable_deployment_circuit_breaker = false
#   enable_rollback                   = false
#   placement_constraint_type         = "memberOf"
#   placement_constraint_expression   = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
#   execution_role_arn                = "arn:aws:iam::027427181034:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
#   task_role_arn                     = "arn:aws:iam::027427181034:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
#   network_mode                      = "bridge"
#   enable_ecs_managed_tags           = true
#   propagate_tags                    = "SERVICE"
#   enable_execute_command            = false
#   health_check_grace_period         = 60
#   iam_role                          = "AWSServiceRoleForEC"
#   environment                       = "prod"
#   vpc_id                            = module.networking.vpc_id
#   tg_name                           = "prod-use1-tg"
#   tg_port                           = 443
#   target_type                       = "instance"
#   healthy_threshold                 = 2
#   unhealthy_threshold               = 2
#   health_check_interval             = 30
#   health_check_path                 = "/api/v1/system"
#   health_check_timeout              = 5
#   create_listener_host_header_rule  = false
#   create_listener_path_pattern_rule = false
#   alb_listener_arn                  = ""
#   priority_host_header              = 0
#   priority_path_pattern             = 0
#   host_header_value                 = []
#   path_pattern_value                = ""
# }

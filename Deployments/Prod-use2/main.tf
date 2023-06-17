# --- prod/us-east-2/main.tf ---
provider "aws" {
  region = "us-east-2"
}

data "terraform_remote_state" "Global" {
  backend = "s3"

  config = {
    bucket = "terraform-state-mgibson"
    key    = "Deployments/global/global.tfstate"
    region = "us-east-1"
  }
}

module "networking" {
  source                     = "../../Modules/networking"
  environment                = "prod"
  vpc_cidr                   = "10.19.0.0/16"
  vpc_name                   = "prod-us-east-2-vpc"
  gw_name                    = "prod-us-east-2-gw"
  nat_eip_name               = "prod-us-east-2-nat-eip"
  nat_gateway_name           = "prod-us-east-2-nat-gw"
  public_subnet_cidr_blocks  = ["10.19.1.0/24", "10.19.2.0/24"]
  private_subnet_cidr_blocks = ["10.19.3.0/24", "10.19.4.0/24"]
  availability_zones         = ["us-east-2a", "us-east-2b"]
  public_subnet_name_prefix  = "public-subnet-prod"
  private_subnet_name_prefix = "private-subnet-prod"
  public_rt_name             = "public-rt-prod"
  private_rt_name            = "private-rt-prod"
  sg_name                    = "prod-us-east-2-sg"
}

module "ec2" {
  source                  = "../../Modules/ec2"
  ami_owner               = "591542846629"
  ami_name                = "al2023-ami-2023.0.20230614.0-kernel-6.1-x86_64"
  launch_template_name    = "prod-ecs-us-east-2-lt"
  environment             = "prod"
  instance_type           = "t2.micro"
  iam_instance_profile    = "arn:aws:iam::*:instance-profile/ecsInstanceRole"
  key_name                = "Keys"
  security_group_lt       = module.networking.sg_id
  instance_name           = "prod-ecs-us-east-2-node"
  user_data               = filebase64("user_data.sh")
  asg_name                = "prod-ecs-us-east-2-asg"
  min_size                = 1
  desired_capacity        = 2
  max_size                = 5
  service_linked_role_arn = "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  subnet_ids              = module.networking.private_subnet_ids
}

module "ecs" {
  source         = "../../Modules/ecs"
  environment    = "prod"
  cluster_name   = "prod-us-east-2-ecs"
}

module "elb" {
  source              = "../../Modules/elb"
  environment         = "prod"
  alb_name            = "prod-use2-alb"
  public_subnets      = module.networking.public_subnet_ids
  alb_sg              = module.networking.sg_id
  listener_port       = 80
  vpc_id                            = module.networking.vpc_id
  tg_name                           = "prod-use2-tg"
  tg_port                           = 80
  target_type                       = "instance"
  healthy_threshold                 = 2
  unhealthy_threshold               = 2
  health_check_interval             = 30
  health_check_path                 = "/health"
  health_check_timeout              = 5
}

module "ecs-service" {
  source                            = "../../Modules/ecs-service"
  ecs_cluster_id                    = module.ecs.ecs_cluster_id
  task_family                       = "hello-world"
  container_definitions             = file("${path.module}/hello-world-cd.json")
  service_name                      = "hello-world-prod"
  desired_count                     = 2
  deployment_max                    = 200
  deployment_min                    = 100
  container_name                    = "hello-world-container"
  container_port                    = 4000
  target_group_arn = module.elb.target_group_arn
  enable_deployment_circuit_breaker = false
  enable_rollback                   = false
  placement_constraint_type         = "memberOf"
  placement_constraint_expression   = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
  execution_role_arn                = "arn:aws:iam::*:role/ECSExectutionRole"
  task_role_arn                     = "arn:aws:iam::*:role/ECSExectutionRole"
  network_mode                      = "bridge"
  enable_ecs_managed_tags           = true
  propagate_tags                    = "SERVICE"
  enable_execute_command            = false
  health_check_grace_period         = 60
  iam_role                          = "arn:aws:iam::*:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}
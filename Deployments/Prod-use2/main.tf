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
  lb_sg_name                 = "prod-us-east-2-lb-sg"
  nacl_name                  = "prod-us-east-2-nacl"
}

module "ec2" {
  source                  = "../../Modules/ec2"
  ami_owner               = "137112412989"
  ami_name                = "al2023-ami-2023.0.20230614.0-kernel-6.1-x86_64"
  launch_template_name    = "prod-ecs-us-east-2-lt"
  environment             = "prod"
  instance_type           = "t2.micro"
  iam_instance_profile    = "arn:aws:iam::027427181034:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  key_name                = "MyKey"
  security_group_lt       = module.networking.sg_id
  instance_name           = "prod-ecs-us-east-2-node"
  user_data               = filebase64("user_data.sh")
  asg_name                = "prod-ecs-us-east-2-asg"
  min_size                = 1
  desired_capacity        = 2
  max_size                = 5
  service_linked_role_arn = "arn:aws:iam::027427181034:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
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
  alb_sg              = module.networking.lb_sg_id
  listener_port       = 443
  access_log_bucket   = "us-east-2-elb-access-logs"
  access_log_path     = "prod-use2-alb"
  vpc_id                            = module.networking.vpc_id
  tg_name                           = "prod-use2-tg"
  tg_port                           = 443
  target_type                       = "instance"
  healthy_threshold                 = 2
  unhealthy_threshold               = 2
  health_check_interval             = 30
  health_check_path                 = "/"
  health_check_timeout              = 5
}

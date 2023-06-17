# ---Global/main.tf---

provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-mgibson"
    key     = "Deployments/global/global.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "s3" {
  source = "../../Modules/s3"
  bucket_name = "mgibson-us-east-2-elb-access-logs"
  environment = "prod"
  enable_encryption = true
  enable_versioning = false
  account_id = "*"
}
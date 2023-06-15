terraform {
  backend "s3" {
    bucket  = "terraform-state-mgibson"
    key     = "Deployments/prod-use1/prod-use1.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
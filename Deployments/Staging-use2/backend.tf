terraform {
  backend "s3" {
    bucket  = "terraform-state-mgibson"
    key     = "Deployments/staging-use2/staging-use2.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
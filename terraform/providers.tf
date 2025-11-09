terraform {
  backend "s3" {
    bucket         = "julio-colon-cmu-hpc-lab-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cmu-hpc-lab-terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

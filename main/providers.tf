terraform {
  backend "s3" {
    bucket  = "ozak-state"
    key     = "infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "nebo"
  }
}
provider "aws" {
  profile = "nebo"
}

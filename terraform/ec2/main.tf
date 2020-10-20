provider "aws" {
  profile = "notes-app"
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

terraform {
  backend "local" {
    path = "../state/db/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../state/vpc/terraform.tfstate"
  }
}
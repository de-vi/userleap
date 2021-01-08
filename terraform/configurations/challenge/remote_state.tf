provider "aws" {
  version                 = "= 3.1.0"
  region                  = var.region
  profile                 = "challenge"
  shared_credentials_file = "$HOME/.aws/credentials"
}

terraform {
  required_version = "= 0.12.29"

  backend "local" {
    path = "./terraform-challenge.tfstate"
  }
  
}


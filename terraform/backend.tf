terraform {
  required_version = "= 0.13.6"
  backend "s3" {
    bucket = "tfstate-userleap-us-east-1-bucket"
    key    = "challenge/tfstate"
    region = "us-east-1"

    dynamodb_table = "userleap-tfstate-lock-db"
    encrypt        = true
  }
}


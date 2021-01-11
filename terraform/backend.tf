terraform {
  required_version = "= 0.12.29"
  backend "s3" {
    bucket = "tfstate-userleap-us-west-1"
    key    = "challenge/tfstate"
    region = "us-west-1"

    dynamodb_table = "userleap-tfstate-lock-db"
    encrypt        = true
  }
}


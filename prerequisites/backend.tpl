terraform {
  required_version = "= 0.13.6"
  backend "s3" {
    bucket = "${state_bucket_name}"
    key    = "challenge/tfstate"
    region = "${region}"

    dynamodb_table = "${lock_db_table}"
    encrypt        = true
  }
}


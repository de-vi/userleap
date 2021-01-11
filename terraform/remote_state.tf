provider "aws" {
  version             = "= 3.23.0"
  region              = var.region
  allowed_account_ids = [var.account_id]
}

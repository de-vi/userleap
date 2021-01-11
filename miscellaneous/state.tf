resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV_AWS_18:No access logging for state bucket
  #checkov:skip=CKV_AWS_52:No MFA delete required for state bucket
  #tfsec:ignore:AWS002
  bucket = var.state_bucket_name
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  #checkov:skip=CKV_AWS_28:No Backup required for Lock DB
  name         = var.dynamodb_lock_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
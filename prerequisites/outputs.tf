output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "access_log_bucket_name" {
  value = aws_s3_bucket.log_bucket.id
}

output "availability_zones" {
  value = slice(data.aws_availability_zones.available.names, 0, 2)
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.id
}

locals {
  name = "${var.service_name}-${var.environment}-${var.project_env}"
  tags = { environment = var.environment, service = var.service_name, project_env = var.project_env }

}

resource "aws_s3_bucket" "log_bucket" {
  #checkov:skip=CKV_AWS_18:No access logging for access log bucket
  #tfsec:ignore:AWS002
  #checkov:skip=CKV_AWS_19:No server side encryption - logs transparently encrypted
  #tfsec:ignore:AWS017
  bucket = "${local.name}-access-log-bucket"
  acl    = "private"
  tags   = local.tags
  versioning {
    enabled = true
    #checkov:skip=CKV_AWS_52:Temporary disable to work around MFA auth issue
    mfa_delete = false
  }
}

resource "aws_s3_bucket_policy" "access_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = templatefile("access_log_bucket_policy.json.tmpl", {
    bucket_name    = aws_s3_bucket.log_bucket.id
    account_id     = var.account_id
    elb_account_id = var.elb_account_id
    name           = local.name
  })
}
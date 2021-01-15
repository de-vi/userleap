data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "elb_account" {}


resource "aws_s3_bucket" "terraform_state" {

  #checkov:skip=CKV_AWS_18:No access logging for state bucket
  #checkov:skip=CKV_AWS_52:No MFA delete required for state bucket
  #tfsec:ignore:AWS002
  bucket_prefix = "${local.name}-tfstate-"
  # Enable versioning so we can see the full revision history of our state files
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
  name         = local.name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  elb_account_id = data.aws_elb_service_account.elb_account.id
  name           = "${var.service_name}-${var.environment}-${var.project_env}"
  tags           = { environment = var.environment, service = var.service_name, project_env = var.project_env }
}

resource "aws_s3_bucket" "log_bucket" {
  #checkov:skip=CKV_AWS_18:No access logging for access log bucket
  #tfsec:ignore:AWS002
  #checkov:skip=CKV_AWS_19:No server side encryption - logs transparently encrypted
  #tfsec:ignore:AWS017

  bucket_prefix = "${local.name}-log-"
  acl           = "private"
  tags          = local.tags
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
    aws_account_id = local.aws_account_id
    applications   = var.applications
    elb_account_id = local.elb_account_id
  })
}

data "template_file" "backend_config" {
  template = file("backend.tpl")
  vars = {
    state_bucket_name = aws_s3_bucket.terraform_state.id
    lock_db_table     = aws_dynamodb_table.terraform_locks.id
    region            = var.region
  }
}

resource "local_file" "backend_file" {
  content    = data.template_file.backend_config.rendered
  filename   = "../terraform/backend.tf"
  depends_on = [null_resource.backend_file]
}

resource "null_resource" "backend_file" {
  provisioner "local-exec" {
    command = "rm ../terraform/backend.tf || true"
  }
}

data "aws_route53_zone" "route53_domain" {
  name = var.route53_domain_name
}

#Issue a certificate from ACM
module "app_cert" {
  source              = "github.com/de-vi/tf-module-aws-acm?ref=v1.0.0"
  route53_record_name = var.route53_record_name
  zone_id             = data.aws_route53_zone.route53_domain.zone_id
}

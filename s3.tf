resource "aws_s3_bucket" "this" {
  bucket = "datadog-${var.account_name}-logs"
  acl    = "private"
  tags = merge(
    local.default_tags, {
      service = "Datadog"
  })
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  lifecycle_rule {
    enabled = true
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

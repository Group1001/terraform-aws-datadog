resource "aws_s3_bucket" "this" {
  bucket = "datadog-${var.namespace}-${var.env}-logs"
  acl    = "private"
  tags = merge(
    local.default_tags, {
      service = "Datadog"
  })

  lifecycle_rule {
    enabled = true
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = "${aws_s3_bucket.this.id}"
  policy = data.aws_iam_policy_document.datadog_rehidration_core.json
}

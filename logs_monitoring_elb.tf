resource "aws_lambda_permission" "allow_elb_log_trigger" {
  count         = var.create_elb_logs_bucket ? 1 : 0
  statement_id  = "AllowExecutionFromELBLogBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.elb_logs[0].arn
}

resource "aws_s3_bucket_notification" "elb_log_notification_datadog_log" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id
  lambda_function {
    lambda_function_arn = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = local.elb_logs_s3_bucket
  acl    = "private"
  policy = data.aws_iam_policy_document.elb_logs.json
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    id      = "log"
    enabled = true
    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 365 # store logs for one year
    }
  }
}

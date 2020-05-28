resource "aws_lambda_permission" "allow_cloudtrail_bucket_trigger" {
  count         = var.cloudtrail_bucket_id != "" ? 1 : 0
  statement_id  = "AllowExecutionFromCTBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
  principal     = "s3.amazonaws.com"
  source_arn    = var.cloudtrail_bucket_arn
}

resource "aws_s3_bucket_notification" "cloudtrail_bucket_notification_dd_log" {
  count  = var.cloudtrail_bucket_id != "" ? 1 : 0
  bucket = var.cloudtrail_bucket_id
  lambda_function {
    lambda_function_arn = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
    events              = ["s3:ObjectCreated:*"]
  }
}

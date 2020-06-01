locals {
  pre_stack_prefix = "${var.account_name}-"
  stack_prefix     = local.pre_stack_prefix == "${var.account_name}--" ? "" : local.pre_stack_prefix
  default_tags = {
    account_name = var.account_name
    account_id   = data.aws_caller_identity.current.account_id
    terraform    = "true"
  }
}

locals {
  elb_logs_s3_bucket = "${var.elb_logs_bucket_prefix}-${var.account_name}-elb-logs"
}

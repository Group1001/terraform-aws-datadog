locals {
  pre_stack_prefix = "${var.namespace}-${var.env}-"
  stack_prefix     = local.pre_stack_prefix == "${var.namespace}--" ? "" : local.pre_stack_prefix
  default_tags = {
    env       = var.env
    namespace = var.namespace
    terraform = "true"
  }
}

locals {
  elb_logs_s3_bucket = "${var.elb_logs_bucket_prefix}-${var.namespace}-${var.env}-elb-logs"
}

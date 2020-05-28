
module "datadog" {
  source                = "app.terraform.io/group-1001/datadog/aws"
  version               = "1.0.6"
  aws_region            = var.aws_region
  datadog_api_key       = var.dd_api_key
  aws_account_id        = data.aws_caller_identity.current.account_id
  env                   = "prod"
  namespace             = "team_foo"
  cloudtrail_bucket_id  = "S3_BUCKET_ID"
  cloudtrail_bucket_arn = "S3_BUCKET_ARN"
  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
  account_specific_namespace_rules = {
    elasticache = true
    network_elb = true
    lambda      = true
  }
}

# terraform-aws-datadog

This module configures the AWS / Datadog integration.

There are two main components:

1. Datadog core integration, enabling [datadog's AWS integration](https://docs.datadoghq.com/integrations/amazon_web_services/)
2. Datadog logs_monitoring forwarder, enabling [logshipping watched S3 buckets](https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring)
  - Forward CloudWatch, ELB, S3, CloudTrail, VPC and CloudFront logs to Datadog
  - Forward S3 events to Datadog
  - Forward Kinesis data stream events to Datadog, only CloudWatch logs are supported
  - Forward custom metrics from AWS Lambda functions via CloudWatch logs
  - Forward traces from AWS Lambda functions via CloudWatch logs
  - Generate and submit enhanced Lambda metrics (`aws.lambda.enhanced.*`) parsed from the AWS REPORT log: duration, billed_duration, max_memory_used, and estimated_cost


## Usage

**Set up all supported AWS / Datadog integrations**

```
module "datadog" {
  source                = "app.terraform.io/group-1001/datadog/aws"
  version               = "1.1.2"
  aws_account_id        = data.aws_caller_identity.current.account_id
  datadog_api_key       = var.datadog_api_key
  account_name          = "team_foo"
  cloudtrail_bucket_id  = aws_s3_bucket.org-cloudtrail-bucket.id
  cloudtrail_bucket_arn = aws_s3_bucket.org-cloudtrail-bucket.arn
  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
  account_specific_namespace_rules = {
    elasticache = true
    network_elb = true
    lambda      = true
  }
}
```

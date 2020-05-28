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
  version               = "1.0.1"
  aws_account_id        = data.aws_caller_identity.current.account_id
  datadog_api_key       = var.datadog_api_key
  env                   = "prod"
  namespace             = "team_foo"
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

Note: The full integration setup should only be done within one terraform stack
per account since some of the resources it creates are global per account.
Creating this module in multiple terraform stacks will cause conflicts.


**Limit to only Cloudwatch log sync**

```
module "datadog" {
  source                         = "app.terraform.io/group-1001/datadog/aws"
  version                        = "1.0.1"
  datadog_api_key                = var.datadog_api_key
  create_elb_logs_bucket         = false
  enable_datadog_aws_integration = false
  env                            = "prod"
  namespace                      = "project_foo"
  cloudwatch_log_groups          = [
    "cloudwatch_log_group_1",
    "cloudwatch_log_group_2"
  ]
}
```

Note: It is safe to create multiple Cloudwatch only modules across different
Terraform stacks within a single AWS account since all resouces used for
Cloudwatch log sync are namspaced by module.

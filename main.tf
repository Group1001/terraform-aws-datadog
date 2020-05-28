resource "datadog_integration_aws" "core" {
  count                            = var.enable_datadog_aws_integration ? 1 : 0
  account_id                       = var.aws_account_id
  role_name                        = "datadog-integration-role"
  account_specific_namespace_rules = var.account_specific_namespace_rules
  host_tags = [
    "Namespace:${var.namespace}",
    "env:${var.env}"
  ]
}

resource "aws_iam_role" "datadog_integration" {
  count              = var.enable_datadog_aws_integration ? 1 : 0
  name               = "datadog-integration-role"
  assume_role_policy = data.aws_iam_policy_document.datadog_role.json
  tags = merge(local.default_tags, {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
  })
}

resource "aws_iam_policy" "datadog_core" {
  count       = var.enable_datadog_aws_integration ? 1 : 0
  name        = "datadog-core-integration"
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"
  policy      = data.aws_iam_policy_document.datadog_core
}

resource "aws_iam_role_policy_attachment" "datadog_core" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  role       = aws_iam_role.datadog_integration[0].name
  policy_arn = aws_iam_policy.datadog_core[0].arn
}

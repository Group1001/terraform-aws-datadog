resource "datadog_integration_aws" "core" {
  count                            = var.enable_datadog_aws_integration ? 1 : 0
  account_id                       = data.aws_caller_identity.current.account_id
  role_name                        = "datadog-integration-role"
  account_specific_namespace_rules = var.account_specific_namespace_rules
  host_tags = [
    "account_name:${var.account_name}",
    "account_id:${data.aws_caller_identity.current.account_id}"
  ]
}

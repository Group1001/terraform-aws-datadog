resource aws_cloudformation_stack "datadog_forwarder" {
  name = "${local.stack_prefix}datadog-forwarder"
  capabilities = [
    "CAPABILITY_IAM",
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND"
  ]
  parameters = {
    DdApiKeySecret = aws_secretsmanager_secret.datadog_api_key.arn
    DdTags         = "namespace:${var.namespace},env:${var.env}"
    ExcludeAtMatch = var.log_exclude_at_match
    FunctionName   = "${local.stack_prefix}datadog-forwarder"
  }
  template_body = data.local_file.datadog_forwarder_cloud_formation_template.content

}

resource aws_secretsmanager_secret "datadog_api_key" {
  name                    = "${local.stack_prefix}dd_api_key"
  description             = "Datadog API Key"
  tags                    = local.default_tags
  recovery_window_in_days = 0
}

resource aws_secretsmanager_secret_version "datadog_api_key" {
  secret_id     = aws_secretsmanager_secret.datadog_api_key.id
  secret_string = var.datadog_api_key
}

variable dd_api_key {
  type        = string
  description = "Datadog's API Key"
}

variable dd_app_key {
  type        = string
  description = "Datadog's APP Key"
}

variable aws_region {
  type        = string
  description = "AWS region in which to spin Datadog's log shipper"
}

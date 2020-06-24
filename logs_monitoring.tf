resource aws_cloudformation_stack "datadog-forwarder" {
  name         = "${local.stack_prefix}datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters   = {
    DdApiKeySecret = aws_secretsmanager_secret.datadog_api_key.arn
    DdApiKey       = "dummy-value"
    DdTags         = "namespace:${var.namespace},env:${var.env}"
    ExcludeAtMatch = var.log_exclude_at_match
    FunctionName   = "${local.stack_prefix}datadog-forwarder"
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/${var.dd_forwarer_template_version}.yaml"
}

resource aws_secretsmanager_secret "datadog_api_key" {
  name        = "${local.stack_prefix}datadog-api-key"
  description = "Datadog API Key"
  tags        = local.default_tags
}

resource aws_secretsmanager_secret_version "datadog_api_key" {
  secret_id     = aws_secretsmanager_secret.datadog_api_key.id
  secret_string = var.datadog_api_key
}

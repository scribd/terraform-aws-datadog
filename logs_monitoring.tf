data "local_file" "template_yaml" {
  filename = "${path.module}/logs_monitoring_template.yaml"
}

resource "aws_cloudformation_stack" "datadog-forwarder" {
  name         = "datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecret = aws_secretsmanager_secret.datadog_api_key.arn
    DdTags         = "namespace:${var.namespace},env:${var.env}"
    ExcludeAtMatch = var.log_exclude_at_match
    FunctionName   = "datadog-forwarder"
  }
  #template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/3.6.0.yaml"
  template_body = data.local_file.template_yaml.content

}

resource "aws_secretsmanager_secret" "datadog_api_key" {
  name        = "datadog_api_key"
  description = "Datadog API Key"
}

resource "aws_secretsmanager_secret_version" "datadog_api_key" {
  secret_id     = aws_secretsmanager_secret.datadog_api_key.id
  secret_string = var.datadog_api_key
}

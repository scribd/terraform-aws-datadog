resource "aws_cloudformation_stack" "datadog-forwarder" {
  name         = "datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKey       = var.datadog_api_key
    DdTags         = "namespace:${var.namespace},env:${var.env}"
    ExcludeAtMatch = var.log_exclude_at_match
    FunctionName   = "datadog-forwarder"
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/3.6.0.yaml"
}

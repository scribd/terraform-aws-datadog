output "datadog_logs_monitoring_lambda_function_name" {
  value = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
}
output "datadog_iam_role" {
  value = var.enable_datadog_aws_integration ? aws_iam_role.datadog-integration[0].name : ""
}

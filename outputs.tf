output "datadog_log_shipping_lambda_function_name" {
  value = aws_lambda_function.dd-log.function_name
}
output "datadog_iam_role" {
  value = aws_iam_role.datadog-integration[0].name
}

output "datadog_log_shipping_lambda_arn" {
  value = aws_lambda_function.dd-log.arn
}
output "datadog_iam_role" {
  value = aws_iam_role.datadog-integration[0].name
}

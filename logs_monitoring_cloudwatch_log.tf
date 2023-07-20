resource "aws_cloudwatch_log_subscription_filter" "test_lambdafunction_logfilter" {
  count           = length(var.cloudwatch_log_groups)
  name            = "${var.cloudwatch_log_groups[count.index]}-filter"
  log_group_name  = var.cloudwatch_log_groups[count.index]
  filter_pattern  = ""
  destination_arn = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  distribution    = "Random"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_to_call_dd_lambda_handler" {
  count         = length(var.cloudwatch_log_groups)
  statement_id  = "${substr(replace(var.cloudwatch_log_groups[count.index], "/", "_"), 0, 67)}-AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.cloudwatch_log_groups[count.index]}:*"
}

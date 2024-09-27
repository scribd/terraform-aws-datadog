resource "aws_cloudwatch_log_subscription_filter" "test_lambdafunction_logfilter" {
  for_each        = { for lg in var.cloudwatch_log_groups : lg => lg }
  name            = "${each.value}-filter"
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  distribution    = "Random"
}

// we're using wildcard sources instead of making separate grant per source
// in order to avoid hitting limit of 20KB per lambda function's aggregated policy size
resource "aws_lambda_permission" "allow_cloudwatch_logs_to_call_dd_lambda_handler" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:*"
}

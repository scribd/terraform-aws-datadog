resource "aws_cloudwatch_log_subscription_filter" "test_lambdafunction_logfilter" {
  for_each        = { for lg in var.cloudwatch_log_groups : lg => lg }
  name            = "${each.value}-filter"
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  distribution    = "Random"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_to_call_dd_lambda_handler" {
  for_each      = { for lg in local.log_groups_to_use : lg => lg }
  statement_id  = "${substr(replace(replace(each.value, "/aws/lambda", ""), "/", "_"), 0, 67)}-CW"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn = (length(var.log_group_prefixes) > 0 ?
    "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${each.value}*" :
  "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${each.value}:*")
}

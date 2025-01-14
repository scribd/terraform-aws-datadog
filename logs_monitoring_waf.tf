# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-waf-bucket-trigger" {
  count         = var.waf_bucket_id != "" ? 1 : 0
  statement_id  = "AllowExecutionFromWAFBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  principal     = "s3.amazonaws.com"
  source_arn    = var.waf_bucket_arn
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "waf-bucket-notification-dd-log" {
  count  = var.waf_bucket_id != "" ? 1 : 0
  bucket = var.waf_bucket_id

  lambda_function {
    filter_prefix       = ".gz"
    lambda_function_arn = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
    events              = ["s3:ObjectCreated:*"]
  }
}


# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-ctbucket-trigger" {
  count  = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  statement_id  = "AllowExecutionFromCTBucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dd-log.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.cloudtrail_bucket_arn}"
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "ctbucket-notification-dd-log" {
  count  = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  bucket = "${var.cloudtrail_bucket_id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.dd-log.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

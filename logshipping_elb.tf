
# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-elblog-trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dd-log.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.elb_logs.arn
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "elblog-notification-dd-log" {
  bucket = aws_s3_bucket.elb_logs.id

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.dd-log.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}


resource "aws_s3_bucket" "elb_logs" {
  bucket = "scribd-${var.namespace}-elb-logs"
  acl    = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 365 # store logs for one year
    }
  }
}


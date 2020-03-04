# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-elblog-trigger" {
  count         = var.create_elb_logs_bucket ? 1 : 0
  statement_id  = "AllowExecutionFromELBLogBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dd-log.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.elb_logs[0].arn
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "elblog-notification-dd-log" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id

  lambda_function {
    lambda_function_arn = aws_lambda_function.dd-log.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

data "aws_elb_service_account" "main" {}

locals {
  elb_logs_s3_bucket = "${var.elb_logs_bucket_prefix}-${var.namespace}-${var.env}-elb-logs"
}

resource "aws_s3_bucket" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = local.elb_logs_s3_bucket
  acl    = "private"
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.elb_logs_s3_bucket}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

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

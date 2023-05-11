# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-elblog-trigger" {
  count         = var.create_elb_logs_bucket ? 1 : 0
  statement_id  = "AllowExecutionFromELBLogBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.elb_logs[0].arn
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "elblog-notification-dd-log" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id

  lambda_function {
    lambda_function_arn = aws_cloudformation_stack.datadog-forwarder.outputs.DatadogForwarderArn
    events              = ["s3:ObjectCreated:*"]
  }
}

data "aws_elb_service_account" "main" {}

locals {
  elb_logs_s3_bucket = "${var.elb_logs_bucket_prefix}-${var.namespace}-${var.env}-elb-logs"
}

data "aws_iam_policy_document" "elb_logs" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${local.elb_logs_s3_bucket}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
    effect = "Allow"
  }
}

resource "aws_s3_bucket" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = local.elb_logs_s3_bucket
}

resource "aws_s3_bucket_policy" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id
  policy = data.aws_iam_policy_document.elb_logs.json
}

resource "aws_s3_bucket_acl" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id

  # Remove old versions of images after 15 days
  rule {
    id = "log"
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
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "elb_logs" {
  count  = var.create_elb_logs_bucket ? 1 : 0
  bucket = aws_s3_bucket.elb_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

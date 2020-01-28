resource "aws_s3_bucket" "scribd_logs" {
  count  = var.create_scribd_logs_bucket ? 1 : 0
  bucket = "scribd-${var.namespace}-scribd-logs"
  acl    = "private"

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

resource "aws_iam_policy" "datadog-scribd-logs-archiving" {
  count       = var.create_scribd_logs_bucket ? 1 : 0
  name        = "datadog-scribd-logs-archiving"
  path        = "/"
  description = "This IAM policy allows for datadog archiving of scribd logs see:https://docs.datadoghq.com/logs/archives/?tab=awss3"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DatadogUploadAndRehydrateLogArchives",
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::scribd-${var.namespace}-scribd-logs/*"
    },
    {
      "Sid": "DatadogRehydrateLogArchivesListBucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::scribd-${var.namespace}-scribd-logs/*"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "datadog-scribd-logs-archiving-attach" {
  count      = var.create_scribd_logs_bucket ? 1 : 0
  role       = "${aws_iam_role.datadog-integration[0].name}"
  policy_arn = "${aws_iam_policy.datadog-scribd-logs-archiving[0].arn}"
}

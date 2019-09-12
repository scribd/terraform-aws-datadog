##
## This tf file will enable datadog integration on scribd-master account
##

resource "aws_iam_role" "datadog-integration" {
  name = "datadog-integration-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::464622532012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.datadog_aws_external_id}"
        }
      }
    }
  ]
}
EOF

  tags = {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
    terraform   = "true"
  }
}

resource "aws_iam_policy" "datadog-core" {
  name        = "datadog-core-integration"
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "apigateway:GET",
        "autoscaling:Describe*",
        "budgets:ViewBudget",
        "cloudfront:GetDistributionConfig",
        "cloudfront:ListDistributions",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "codedeploy:List*",
        "codedeploy:BatchGet*",
        "directconnect:Describe*",
        "dynamodb:List*",
        "dynamodb:Describe*",
        "ec2:Describe*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeTags",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:List*",
        "elasticmapreduce:Describe*",
        "es:ListTags",
        "es:ListDomainNames",
        "es:DescribeElasticsearchDomains",
        "health:DescribeEvents",
        "health:DescribeEventDetails",
        "health:DescribeAffectedEntities",
        "kinesis:List*",
        "kinesis:Describe*",
        "lambda:AddPermission",
        "lambda:GetPolicy",
        "lambda:List*",
        "lambda:RemovePermission",
        "logs:Get*",
        "logs:Describe*",
        "logs:FilterLogEvents",
        "logs:TestMetricFilter",
        "logs:PutSubscriptionFilter",
        "logs:DeleteSubscriptionFilter",
        "logs:DescribeSubscriptionFilters",
        "rds:Describe*",
        "rds:List*",
        "redshift:DescribeClusters",
        "redshift:DescribeLoggingStatus",
        "route53:List*",
        "s3:GetBucketLogging",
        "s3:GetBucketLocation",
        "s3:GetBucketNotification",
        "s3:GetBucketTagging",
        "s3:ListAllMyBuckets",
        "s3:PutBucketNotification",
        "ses:Get*",
        "sns:List*",
        "sns:Publish",
        "sqs:ListQueues",
        "support:*",
        "tag:GetResources",
        "tag:GetTagKeys",
        "tag:GetTagValues",
        "xray:BatchGetTraces",
        "xray:GetTraceSummaries"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog-core-attach" {
  role       = "${aws_iam_role.datadog-integration.name}"
  policy_arn = "${aws_iam_policy.datadog-core.arn}"
}

resource "aws_iam_policy" "datadog-cloudtrail" {
  name        = "datadog-cloudtrail-integration"
  path        = "/"
  description = "This IAM policy allows for cloudtrail datadog integration permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
              "s3:List*",
              "s3:Get*",
              "s3:Describe*",
              "cloudtrail:DescribeTrails",
              "cloudtrail:GetTrailStatus"
          ],
          "Resource": [
              "arn:aws:s3:::${var.cloudtrail_bucket_id}",
              "arn:aws:s3:::${var.cloudtrail_bucket_id}/*"
          ],
          "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog-cloudtrail-attach" {
  role       = "${aws_iam_role.datadog-integration.name}"
  policy_arn = "${aws_iam_policy.datadog-cloudtrail.arn}"
}

# Create a lambda function that will export CT logs to DD
resource "aws_iam_role" "dd-log-lambda" {
  name = "dd_log_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog-cloudtrail-lambda-attach" {
  role       = "${aws_iam_role.dd-log-lambda.name}"
  policy_arn = "${aws_iam_policy.datadog-cloudtrail.arn}"
}

resource "aws_lambda_function" "dd-log" {
  filename      = "files/dd_log_lambda.zip"
  function_name = "DatadogLambdaFunction"
  role          = "${aws_iam_role.dd-log-lambda.arn}"
  handler       = "lambda_function.lambda_handler"
  description   = "This lambda function will export logs to our orgs Datadog events"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("files/dd_log_lambda.zip")}"

  runtime     = "python2.7"
  memory_size = "1024"
  timeout     = "120"

  # This brings in requirements for the lambda to run (imports modules)
  # This allows the dd_log_lambda.zip to be very small https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
  # This specific layer is: https://github.com/DataDog/datadog-lambda-layer-python
  layers = ["arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:layer:Datadog-Python27:3"]

  environment {
    variables = {
      DD_API_KEY = var.datadog_key
    }
  }
}

# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-ctbucket-trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dd-log.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.cloudtrail_bucket_arn}"
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "bucket-notification-dd-log" {
  bucket = "${var.cloudtrail_bucket_id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.dd-log.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

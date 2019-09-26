resource "aws_iam_policy" "datadog-logshipping" {
  name        = "datadog-logshipping-integration"
  path        = "/"
  description = "This IAM policy allows for logshipping aws logs. See https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions#manually-setup-triggers"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
            "cloudfront:GetDistributionConfig",
            "cloudfront:ListDistributions",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "lambda:AddPermission",
            "lambda:GetPolicy",
            "lambda:RemovePermission",
            "redshift:DescribeClusters",
            "redshift:DescribeLoggingStatus",
            "s3:GetBucketLogging",
            "s3:GetBucketLocation",
            "s3:GetBucketNotification",
            "s3:ListAllMyBuckets",
            "s3:PutBucketNotification",
            "s3:GetObject",
            "logs:PutSubscriptionFilter",
            "logs:DeleteSubscriptionFilter",
            "logs:DescribeSubscriptionFilters"
          ],
          "Resource": "*",
          "Effect": "Allow"
        }
    ]
}
EOF
}

# Create a lambda function that will export CT logs to DD
resource "aws_iam_role" "dd-log-lambda" {
  name  = "dd_log_lambda"

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

resource "aws_iam_role_policy_attachment" "datadog-logshipping-lambda-attach" {
  role       = "${aws_iam_role.dd-log-lambda.name}"
  policy_arn = "${aws_iam_policy.datadog-logshipping.arn}"
}

resource "aws_iam_role_policy_attachment" "datadog-logshipping-lambda-attach2" {
  role       = "${aws_iam_role.dd-log-lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "datadog-logshipping-lambda-attach3" {
  role       = "${aws_iam_role.dd-log-lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}
resource "aws_lambda_function" "dd-log" {
  filename      = "${path.module}/files/dd_log_lambda.zip"
  function_name = "${var.namespace}_DatadogLambdaFunction"
  role          = "${aws_iam_role.dd-log-lambda.arn}"
  handler       = "lambda_function.lambda_handler"
  description   = "This lambda function will export logs to our orgs Datadog events"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/files/dd_log_lambda.zip")}"

  runtime     = "python2.7"
  memory_size = "1024"
  timeout     = "120"

  # This brings in requirements for the lambda to run (imports modules)
  # This allows the dd_log_lambda.zip to be very small https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
  # This specific layer is: https://github.com/DataDog/datadog-lambda-layer-python
  layers = ["arn:aws:lambda:${var.aws_region}:464622532012:layer:Datadog-Python27:3"]

  environment {
    variables = {
      DD_API_KEY = var.datadog_api_key
    }
  }
}

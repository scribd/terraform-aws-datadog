
resource "aws_iam_policy" "datadog-cloudtrail" {
  count       = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
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
  count      = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  role       = "${aws_iam_role.datadog-integration.name}"
  policy_arn = "${aws_iam_policy.datadog-cloudtrail[count.index].arn}"
}

# Create a lambda function that will export CT logs to DD
resource "aws_iam_role" "dd-log-lambda" {
  count = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
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

resource "aws_iam_role_policy_attachment" "datadog-cloudtrail-lambda-attach" {
  count      = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  role       = "${aws_iam_role.dd-log-lambda[count.index].name}"
  policy_arn = "${aws_iam_policy.datadog-cloudtrail[count.index].arn}"
}

resource "aws_lambda_function" "dd-log" {
  count         = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  filename      = "files/dd_log_lambda.zip"
  function_name = "DatadogLambdaFunction"
  role          = "${aws_iam_role.dd-log-lambda[count.index].arn}"
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

# Make lambda function accept invokes from S3
resource "aws_lambda_permission" "allow-ctbucket-trigger" {
  count         = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dd-log[count.index].arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.cloudtrail_bucket_arn}"
}

# Tell S3 bucket to invoke DD lambda once an object is created/modified
resource "aws_s3_bucket_notification" "bucket-notification-dd-log" {
  count  = "${var.cloudtrail_bucket_id != "" ? 1 : 0}"
  bucket = "${var.cloudtrail_bucket_id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.dd-log[count.index].arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

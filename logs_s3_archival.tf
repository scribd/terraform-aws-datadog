resource "aws_iam_policy" "datadog-s3-archival" {
  count       = var.enable_datadog_aws_integration && var.enable_logs_s3_archival ? 1 : 0
  name        = "datadog-s3-archival"
  path        = "/"
  description = "This IAM policy allows for datadog s3 archival & rehydration permissions"

  policy = <<EOF
{
  "version": "2012-10-17",
  "statement": [
    {
      "effect": "allow",
      "action": [
        "s3:putobject",
        "s3:getobject"
      ],
      "resource": [
        "arn:aws:s3:::${var.logs_s3_archival_bucket_name}/*"
      ]
    },
    {
      "effect": "allow",
      "action": "s3:listbucket",
      "resource": [
        "arn:aws:s3:::${var.logs_s3_archival_bucket_name}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog-s3-archival-attach" {
  count      = var.enable_datadog_aws_integration && var.enable_logs_s3_archival ? 1 : 0
  role       = aws_iam_role.datadog-integration[0].name
  policy_arn = aws_iam_policy.datadog-s3-archival[0].arn
}

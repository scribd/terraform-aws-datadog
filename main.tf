## This tf file will setup Datadog AWS integration

resource "datadog_integration_aws" "core" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  account_id = var.aws_account_id
  role_name  = "datadog-integration-role"

  host_tags = var.host_tags

  account_specific_namespace_rules = var.account_specific_namespace_rules
  excluded_regions                 = var.excluded_regions
  filter_tags                      = var.filter_tags
  resource_collection_enabled      = var.resource_collection_enabled
  metrics_collection_enabled       = var.metrics_collection_enabled
  cspm_resource_collection_enabled = var.cspm_resource_collection_enabled
}

# resource "datadog_integration_aws_tag_filter" "rds-tag-filters"{
#   count      = var.enable_datadog_aws_integration ? 1 : 0
#   account_id     = var.aws_account_id
#   namespace      = "rds"
#   tag_filter_str = "environment:*-prod"
# }


resource "aws_iam_role" "datadog-integration" {
  count = var.enable_datadog_aws_integration ? 1 : 0
  name  = "datadog-integration-role"

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
          "sts:ExternalId": "${datadog_integration_aws.core[0].external_id}"
        }
      }
    }
  ]
}
EOF

  tags = merge(local.default_tags, {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
  })
}

data "aws_iam_policy" "securityAudit" {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "datadog-core" {
  count       = var.enable_datadog_aws_integration ? 1 : 0
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
        "cloudformation:DetectStack*",
        "cloudfront:GetDistributionConfig",
        "cloudfront:ListDistributions",
        "cloudtrail:LookupEvents",
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
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstances",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeTags",
        "elasticloadbalancing:Describe*",
        "elasticmapreduce:List*",
        "elasticmapreduce:Describe*",
        "es:ListTags",
        "es:ListDomainNames",
        "es:DescribeElasticsearchDomains",
        "fsx:DescribeFileSystems",
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
        "organizations:DescribeOrganization",
        "organizations:ListRoots",
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
        "backup:ListBackupPlans",
        "ses:Get*",
        "sns:List*",
        "sns:Publish",
        "states:ListStateMachines",
        "states:DescribeStateMachine",
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

resource "aws_iam_role_policy_attachment" "cpsm-resource-collection" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  role       = aws_iam_role.datadog-integration[0].name
  policy_arn = data.aws_iam_policy.securityAudit.arn
}

resource "aws_iam_role_policy_attachment" "datadog-core-attach" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  role       = aws_iam_role.datadog-integration[0].name
  policy_arn = aws_iam_policy.datadog-core[0].arn
}

resource "aws_iam_role_policy_attachment" "datadog-core-attach-extras" {
  for_each   = toset(var.extra_policy_arns)
  role       = aws_iam_role.datadog-integration[0].name
  policy_arn = each.value
}

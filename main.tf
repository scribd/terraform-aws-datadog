## This tf file will setup Datadog AWS integration

resource "datadog_integration_aws_account" "core" {
  count          = var.enable_datadog_aws_integration ? 1 : 0
  aws_account_id = var.aws_account_id
  # Commercial partition only: the trust policy below pins arn:aws: and Datadog's
  # US integration account, neither of which is valid in aws-cn or aws-us-gov.
  aws_partition = "aws"

  account_tags = [
    "Namespace:${var.namespace}",
    "env:${var.env}"
  ]

  auth_config {
    aws_auth_config_role {
      role_name = "datadog-integration-role"
    }
  }

  # The provider rejects include_all and include_only being set together, so the
  # unused side has to be null rather than false or []. Same for the filters below.
  aws_regions {
    include_all  = length(var.included_regions) > 0 ? null : true
    include_only = length(var.included_regions) > 0 ? var.included_regions : null
  }

  logs_config {
    lambda_forwarder {
      lambdas = var.logs_lambda_forwarder_arns
      sources = var.logs_sources
    }
  }

  metrics_config {
    enabled                   = var.metrics_enabled
    automute_enabled          = var.metrics_automute_enabled
    collect_cloudwatch_alarms = var.metrics_collect_cloudwatch_alarms
    collect_custom_metrics    = var.metrics_collect_custom_metrics

    namespace_filters {
      include_only = local.metrics_namespace_include_only
      exclude_only = local.metrics_namespace_exclude_only
    }

    # Sent as a full replacement on every apply, so a namespace absent here has
    # its filters cleared in Datadog.
    dynamic "tag_filters" {
      for_each = local.metrics_tag_filters
      content {
        namespace = tag_filters.key
        tags      = tag_filters.value
      }
    }
  }

  resources_config {
    extended_collection                          = var.resources_extended_collection
    cloud_security_posture_management_collection = var.resources_cspm_collection
  }

  traces_config {
    xray_services {
      include_all  = var.xray_include_all ? true : null
      include_only = length(var.xray_services) > 0 ? var.xray_services : null
    }
  }
}

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
          "sts:ExternalId": "${datadog_integration_aws_account.core[0].auth_config.aws_auth_config_role.external_id}"
        }
      }
    }
  ]
}
EOF

  tags = merge(local.default_tags, {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
  }, var.tags)
}

resource "aws_iam_policy" "datadog-core" {
  count       = var.enable_datadog_aws_integration ? 1 : 0
  name        = "datadog-core-integration"
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"
  tags        = merge(local.default_tags, var.tags)
  policy      = <<EOF
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

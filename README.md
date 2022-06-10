# terraform-aws-datadog

[![cicd](https://github.com/scribd/terraform-aws-datadog/workflows/CICD/badge.svg)](https://github.com/scribd/terraform-aws-datadog/actions)
[![terraformregistry](https://img.shields.io/badge/terraform-registry-blueviolet)](https://registry.terraform.io/modules/scribd/datadog/aws)

This module configures the AWS / Datadog integration.

There are two main components:

1. Datadog core integration, enabling [datadog's AWS integration](https://docs.datadoghq.com/integrations/amazon_web_services/)
2. Datadog logs_monitoring forwarder, enabling [logshipping watched S3 buckets](https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/logs_monitoring)
  - Forward CloudWatch, ELB, S3, CloudTrail, VPC and CloudFront logs to Datadog
  - Forward S3 events to Datadog
  - Forward Kinesis data stream events to Datadog, only CloudWatch logs are supported
  - Forward custom metrics from AWS Lambda functions via CloudWatch logs
  - Forward traces from AWS Lambda functions via CloudWatch logs
  - Generate and submit enhanced Lambda metrics (`aws.lambda.enhanced.*`) parsed from the AWS REPORT log: duration, billed_duration, max_memory_used, and estimated_cost


## Usage

**Set up all supported AWS / Datadog integrations**

```
module "datadog" {
  source                = "scribd/datadog/aws"
  version               = "~>1"
  aws_account_id        = data.aws_caller_identity.current.account_id
  datadog_api_key       = var.datadog_api_key
  env                   = "prod"
  namespace             = "team_foo"

  cloudtrail_bucket_id  = aws_s3_bucket.org-cloudtrail-bucket.id
  cloudtrail_bucket_arn = aws_s3_bucket.org-cloudtrail-bucket.arn

  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]

  account_specific_namespace_rules = {
    elasticache = true
    network_elb = true
    lambda      = true
  }
}
```

Note: The full integration setup should only be done within one terraform stack
per account since some of the resources it creates are global per account.
Creating this module in multiple terraform stacks will cause conflicts.


**Limit to only Cloudwatch log sync**

```
module "datadog" {
  source                         = "scribd/datadog/aws"
  version                        = "~>1"
  datadog_api_key                = var.datadog_api_key
  create_elb_logs_bucket         = false
  enable_datadog_aws_integration = false
  env                            = "prod"
  namespace                      = "project_foo"

  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}
```

Note: It is safe to create multiple Cloudwatch only modules across different
Terraform stacks within a single AWS account since all resouces used for
Cloudwatch log sync are namspaced by module.

**Be certain to use unique  `namespace`/`env` combinations, to avoid conflict with other instances of this module.

## Module Versions

**Version 3.x.x** and greater require terraform version > 0.13.x and AWS provider > 4.0.0.
**Version 2.x.x** and greater require terraform version > 0.13.x and AWS provider < 4.0.0.  
**Version 1.x.x** is the latest version that support terraform version 0.12.x and AWS provider < 4.0.0.  
When using this module, please be sure to [pin to a compatible version](https://www.terraform.io/docs/configuration/modules.html#module-versions).

## Examples

- [Full AWS Datadog integration](https://github.com/scribd/terraform-aws-datadog/tree/master/examples/full_integration)
- [Cloudwatch log sync only](https://github.com/scribd/terraform-aws-datadog/tree/master/examples/cloudwatch_log_sync)


## Development

Releases are cut using [semantic-release](https://github.com/semantic-release/semantic-release).

Please write commit messages following [Angular commit guidelines](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)


### Release flow

Semantic-release is configured with the [default branch workflow](https://semantic-release.gitbook.io/semantic-release/usage/configuration#branches)

For this project, releases will be cut from master as features and bugs are developed.


### Maintainers
- [Jim](https://github.com/jim80net)
- [QP](https://github.com/houqp)

## Troubleshooting

If you should encounter `Datadog is not authorized to perform action sts:AssumeRole Accounts affected: 1234567890, 1234567891 Regions affected: every region Errors began reporting 18m ago, last seen 5m ago`
Then perhaps the external ID has changed. Execute `./terraform taint module.datadog.datadog_integration_aws.core[0]` in the root module of the account repo to force a refresh.

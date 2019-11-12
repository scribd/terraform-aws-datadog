# datadog

This module configures the AWS / Datadog integration.

- Can configure cloudtrail logshipping
- Can create elb s3 bucket for logs and logshipping
- Can sync cloudwatch logs for a given list of log groups


## Usage

**Org Master With CloudTrail**

```
module "datadog" {
  source = "git::ssh://git@git.lo/terraform/terraform-aws-datadog?ref=master"


  aws_account_id        = data.aws_caller_identity.current.account_id
  cloudtrail_bucket_id  = aws_s3_bucket.org-cloudtrail-bucket.id
  cloudtrail_bucket_arn = aws_s3_bucket.org-cloudtrail-bucket.arn
  datadog_api_key       = var.datadog_api_key
}
```

**Normal**

```
module "datadog" {
  source = "git::ssh://git@git.lo/terraform/terraform-aws-datadog?ref=master"

  aws_account_id      = var.aws_account_id
}
```

**Limit to only cloudwatch log sync**

```
module "datadog" {
  source = "git::ssh://git@git.lo/terraform/terraform-aws-datadog?ref=master"

  aws_account_id                 = var.aws_account_id
  create_elb_logs_bucket         = false
  enable_datadog_aws_integration = false
  cloudwatch_log_groups          = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}
```

# datadog

This module configures the AWS / Datadog integration.

- Can configure cloudtrail logshipping
- Can create elb s3 bucket for logs and logshipping
- Can sync cloudwatch logs for a given list of log groups


## Usage

**Org Master With CloudTrail**

```
module "datadog" {
  source = "../modules/datadog"

  aws_account_id        = data.aws_caller_identity.current.account_id
  cloudtrail_bucket_id  = aws_s3_bucket.org-cloudtrail-bucket.id
  cloudtrail_bucket_arn = aws_s3_bucket.org-cloudtrail-bucket.arn
  datadog_api_key       = var.datadog_api_key
}
```

**Normal**

```
module "datadog" {
  source = "../modules/datadog"

  aws_account_id      = var.aws_account_id
}
```

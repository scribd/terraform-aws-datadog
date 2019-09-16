# datadog

This module configures the AWS / Datadog integration


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

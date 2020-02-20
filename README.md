# terraform-aws-datadog

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

## Development

Releases are cut using [go-semrel-gitlab](https://gitlab.com/juhani/go-semrel-gitlab)

Format commit messages using [Conventional Commits format](https://www.conventionalcommits.org/en/v1.0.0-beta.2/) to determine the next version bump and to produce release notes

```
type(scope): subject
```
or

```
type: subject
```

Types:
```
minor bump: feat
patch bump: fix,refactor,perf,docs,style,tes
```

When a commit contains a breaking change, the commit message should contain `BREAKING CHANGE:`

## Cutting a release

- Merge into master 
- Watch the pipeline, or not.
- You have two methods for convergence of the release across the organization. 
  -  Push: Search for `source = "git::ssh://git@git.lo/terraform/terraform-aws-datadog?ref=` amongst all git.lo/terraform repos. I have a [checkout of all projects](https://git.lo/jimp/jimtools/blob/master/update_all.sh) in this group to facilitate doing this using ripgrep. Make an MR and communicate the changes + MR
  -  Pull: Communicate the change to a public channel to facilitate people updating their versions.
  -  Future TODO: Publish these releases to a public registry so that consumers can [automatically follow releases according to SemVer rules](https://www.terraform.io/docs/configuration/modules.html#module-versions). 
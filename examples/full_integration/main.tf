variable dd_api_key {
  type    = string
  default = "1234567890"
}

variable dd_app_key {
  type    = string
  default = "1234567890"
}

variable aws_region {
  type    = string
  default = "us-west-2"
}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
}

provider "aws" {
  region = var.aws_region
}

module "datadog" {
  source          = "scribd/datadog/aws"
  version         = "~>1"
  aws_region      = var.aws_region
  datadog_api_key = var.dd_api_key
  datadog_app_key = var.dd_app_key
  aws_account_id  = data.aws_caller_identity.current.account_id

  cloudtrail_bucket_id  = "S3_BUCKET_ID"
  cloudtrail_bucket_arn = "S3_BUCKET_ARN"

  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}

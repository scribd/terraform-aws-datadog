module "datadog" {
  source = "../"
  aws_region      = "us-east-2"
  datadog_api_key = "1234567890"
  aws_account_id  = "1234567890"
}

module "datadog" {
  source = "../"

  datadog_api_key = "1234567890"
  aws_account_id  = "1234567890"
  region          = "us-east-2"
}

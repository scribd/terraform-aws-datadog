variable "aws_account_id" {
  description = "The ID of the AWS account to create the integration for"
  type = "string"
}
variable "aws_region" {
  description = "AWS Region"
  type = "string"
  default = "us-east-2"
}
variable "cloudtrail_bucket_id" {
  description = "The Cloudtrail bucket ID"
  type = "string"
  default = ""
}
variable "cloudtrail_bucket_arn" {
  description = "The Cloudtrail bucket ID"
  type = "string"
  default = ""
}
variable "datadog_key" {
  description = "The API key for the datadog integration"
  type = "string"
}
variable "datadog_aws_external_id" {
  description = "The External ID provided by datadog in datadog's AWS configuration page"
  type = "string"
  default = "98eaaa12e88649709f5e3a61454fcdd5"
}

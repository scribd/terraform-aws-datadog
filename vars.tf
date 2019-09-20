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
  description = "The Cloudtrail bucket ID. Use only from org master account."
  type = "string"
  default = ""
}
variable "cloudtrail_bucket_arn" {
  description = "The Cloudtrail bucket ID. Use only from org master account"
  type = "string"
  default = ""
}
variable "datadog_api_key" {
  description = "The API key for the datadog integration."
  type = "string"
}
variable "namespace" {
  description = "The namespace tag to apply to all hosts in the integration"
  type = "string"
  default = "test"
}

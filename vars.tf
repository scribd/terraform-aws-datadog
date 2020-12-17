variable "aws_account_id" {
  description = "The ID of the AWS account to create the integration for"
  type        = string
  default     = "" # only needed if enable_datadog_aws_integration is set to true
}
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}
variable "cloudtrail_bucket_id" {
  description = "The Cloudtrail bucket ID. Use only from org master account."
  type        = string
  default     = ""
}
variable "cloudtrail_bucket_arn" {
  description = "The Cloudtrail bucket ID. Use only from org master account"
  type        = string
  default     = ""
}
variable "datadog_api_key" {
  description = "The API key for the datadog integration."
  type        = string
}
variable "namespace" {
  description = "The namespace tag to apply to all data sent to datadog"
  type        = string
  default     = ""
}
variable "create_elb_logs_bucket" {
  description = "Create S3 bucket for ELB log sync"
  default     = true
  type        = bool
}
variable "cloudwatch_log_groups" {
  description = "Sync logs from cloudwatch by given list of log groups"
  type        = list(string)
  default     = []
}
variable "enable_datadog_aws_integration" {
  description = "Use datadog provider to give datadog aws account access to our resources"
  type        = bool
  default     = true
}
variable "env" {
  description = "The env tag to apply to all data sent to datadog"
  type        = string
  default     = ""
}
variable "account_specific_namespace_rules" {
  description = "account_specific_namespace_rules argument for datadog_integration_aws resource"
  type        = map
  default     = {}
}
variable "elb_logs_bucket_prefix" {
  description = "Prefix for ELB logs S3 bucket name"
  type        = string
  default     = "awsdd"
}
variable "log_exclude_at_match" {
  description = "Sets EXCLUDE_AT_MATCH environment variable, which allows excluding unwanted log lines"
  type        = string
  default     = "$x^" # <- never matches anything
}

variable "dd_forwarder_template_version" {
  description = "Sets Datadog Forwarder version to use"
  type        = string
  default     = "3.17.0"
}

variable "dd_forwarder_dd_site" {
  type        = string
  default     = "datadoghq.com"
  description = "Define your Datadog Site to send data to. For the Datadog EU site, set to datadoghq.eu"
}

variable "excluded_regions" {
  description = "An array of AWS regions to exclude from metrics collection"
  type        = list(string)
  default     = []
}

variable "filter_tags" {
  description = "Array of EC2 tags (in the form key:value) defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used. Only hosts that match one of the defined tags will be imported into Datadog. The rest will be ignored."
  type        = list(string)
  default     = []
}

variable "enable_logs_s3_archival" {
  description = "Enable adding rights for Datadog S3 archival"
  type        = bool
  default     = false
}

variable "logs_s3_archival_bucket_name" {
  description = "S3 bucket to use for archival"
  type        = string
  default     = "" # only needed if enable_logs_s3_archival is set to true
}

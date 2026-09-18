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
variable "log_group_prefixes" {
  description = "List of CloudWatch Log Group prefixes to create lambda permissions"
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
variable "metrics_namespace_include_only" {
  description = "Collect metrics only from these CloudWatch namespaces, e.g. [\"AWS/EC2\", \"AWS/RDS\"]. Mutually exclusive with metrics_namespace_exclude_only."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "metrics_namespace_exclude_only" {
  description = "Exclude these CloudWatch namespaces from metrics collection. Empty means the Datadog default of [\"AWS/SQS\", \"AWS/ElasticMapReduce\", \"AWS/Usage\"]. Mutually exclusive with metrics_namespace_include_only."
  type        = list(string)
  default     = []
  nullable    = false
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
  default     = "3.100.0"
}

variable "dd_forwarder_memory_size" {
  description = "Memory size for the Datadog Forwarder Lambda function"
  type        = number
  default     = 1024
}

variable "dd_forwarder_dd_site" {
  type        = string
  default     = "datadoghq.com"
  description = "Define your Datadog Site to send data to. For the Datadog EU site, set to datadoghq.eu"
}

variable "included_regions" {
  description = "An array of AWS regions to collect data from. Empty means all regions. The Datadog AWS integration API has no exclusion form, so regions to skip must be expressed by listing the ones to keep."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "metrics_tag_filters" {
  description = "Metrics tag filters keyed by CloudWatch namespace, e.g. { \"AWS/SQS\" = [\"env:prod\"] }. Merged with filter_tags, which covers AWS/EC2; an AWS/EC2 key here wins over filter_tags. A namespace absent from both has its tag filters cleared in Datadog on apply."
  type        = map(list(string))
  default     = {}
  nullable    = false

  validation {
    condition     = alltrue([for tags in values(var.metrics_tag_filters) : length(tags) > 0])
    error_message = "Each namespace in metrics_tag_filters needs at least one tag. Drop the namespace key rather than giving it an empty list; absence already means no filter."
  }
}

variable "metrics_enabled" {
  description = "Enable AWS CloudWatch metrics collection"
  type        = bool
  default     = true
}

variable "metrics_automute_enabled" {
  description = "Enable EC2 automute for AWS metrics"
  type        = bool
  default     = true
}

variable "metrics_collect_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms collection"
  type        = bool
  default     = false
}

variable "metrics_collect_custom_metrics" {
  description = "Enable custom metrics collection"
  type        = bool
  default     = false
}

variable "resources_extended_collection" {
  description = "Whether Datadog collects additional attributes and configuration information about resources in the account. Required for resources_cspm_collection."
  type        = bool
  default     = true
}

variable "resources_cspm_collection" {
  description = "Enable Cloud Security Management scanning of AWS resources. Requires resources_extended_collection."
  type        = bool
  default     = false
}

variable "logs_lambda_forwarder_arns" {
  description = "Lambda Log Forwarder ARNs for Datadog to autosubscribe to log groups. Empty CLEARS any Datadog-side autosubscription on apply; the CloudWatch subscription filters this module creates from cloudwatch_log_groups are unaffected."
  type        = list(string)
  default     = []
}

variable "logs_sources" {
  description = "AWS service IDs to enable automatic log collection for, e.g. [\"s3\", \"lambda\"]. Requires logs_lambda_forwarder_arns. Empty CLEARS any sources configured in Datadog."
  type        = list(string)
  default     = []
}

variable "xray_include_all" {
  description = "Collect X-Ray traces from all services. Mutually exclusive with xray_services."
  type        = bool
  default     = false
}

variable "xray_services" {
  description = "Collect X-Ray traces only from these services. Empty means no X-Ray collection."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "filter_tags" {
  description = "Array of EC2 tags (in the form key:value) defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used. Only hosts that match one of the defined tags will be imported into Datadog. The rest will be ignored."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "extra_policy_arns" {
  description = "Extra policy arns to attach to the datadog-integration-role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

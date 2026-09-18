locals {
  stack_prefix = var.env == "" ? "" : "${join("-", compact([var.namespace, var.env]))}-"
  default_tags = {
    env       = var.env
    namespace = var.namespace
    terraform = "true"
  }
  log_groups_to_use = length(var.log_group_prefixes) > 0 ? var.log_group_prefixes : var.cloudwatch_log_groups

  metrics_namespace_include_only = length(var.metrics_namespace_include_only) > 0 ? var.metrics_namespace_include_only : null
  metrics_namespace_exclude_only = length(var.metrics_namespace_exclude_only) > 0 ? var.metrics_namespace_exclude_only : null

  metrics_tag_filters = merge(
    length(var.filter_tags) > 0 ? { "AWS/EC2" = var.filter_tags } : {},
    var.metrics_tag_filters,
  )
}

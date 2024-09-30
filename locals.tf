locals {
  stack_prefix = var.env == "" ? "" : "${join("-", compact([var.namespace, var.env]))}-"
  default_tags = {
    env       = var.env
    namespace = var.namespace
    terraform = "true"
  }
  log_groups_to_use = length(var.log_group_prefixes) > 0 ? var.log_group_prefixes : var.cloudwatch_log_groups
}

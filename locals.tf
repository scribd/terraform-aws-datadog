locals {
  # default to namespace for backwards compatibility
  pre_stack_prefix = "${var.namespace}-${var.env}-"
  stack_prefix     = local.pre_stack_prefix == "${var.namespace}--" ? "" : local.pre_stack_prefix

  default_tags = {
    env       = var.env
    namespace = var.namespace
    terraform = "true"
  }
}

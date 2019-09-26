locals {
  # default to namespace for backwards compatibility
  env       = var.env == "" ? var.namespace : var.env
  stack_uid = "${var.namespace}-${var.env}"

  default_tags = {
    env       = local.env
    namespace = var.namespace
    terraform = "true"
  }
}

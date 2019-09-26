locals {
  # default to namespace for backwards compatibility
  env = var.env == "" ? var.namespace : var.env
}

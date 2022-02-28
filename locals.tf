locals {
  stack_prefix = var.env == "" ? "" : "${join("-", compact([var.namespace, var.env]))}-"
}

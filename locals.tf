locals {
  prefix      = "${var.project_name}-${var.environment}"
  safe_prefix = lower(replace(local.prefix, "-", ""))
}

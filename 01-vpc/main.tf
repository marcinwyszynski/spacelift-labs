data "aws_region" "this" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "spacelift_environment_variable" "vpc_id" {
  context_id = var.shared_context_id
  name       = "TF_VAR_vpc_id"
  value      = aws_vpc.main.id
  write_only = false
}

resource "spacelift_environment_variable" "aws_region" {
  context_id = var.shared_context_id
  name       = "AWS_REGION"
  value      = data.aws_region.this.name
  write_only = false
}

resource "spacelift_environment_variable" "aws_role_arn" {
  context_id = var.shared_context_id
  name       = "TF_VAR_aws_role_arn"
  value      = var.aws_role_arn
  write_only = false
}

output "vpc_id" {
  value = aws_vpc.main.id
}

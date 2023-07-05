variable "aws_role_arn" {
  type        = string
  description = "ARN of the IAM role to assume"
}

variable "shared_context_id" {
  type        = string
  description = "ID of the shared context for the lab"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to use"
}

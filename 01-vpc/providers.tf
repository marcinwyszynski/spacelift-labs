terraform {
  required_providers {
    aws       = { source = "hashicorp/aws" }
    spacelift = { source = "spacelift-io/spacelift" }
  }
}

provider "spacelift" {}

provider "aws" {
  assume_role_with_web_identity {
    role_arn                = var.aws_role_arn
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }
}

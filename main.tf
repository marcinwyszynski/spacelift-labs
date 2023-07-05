data "spacelift_current_space" "this" {}

locals {
  labels = ["labs", "aws", "networking"]
}

resource "spacelift_context" "networking-labs" {
  name     = "AWS Networking labs"
  space_id = data.spacelift_current_space.this.id
  labels   = local.labels
}

resource "spacelift_blueprint" "lesson-01-vpc" {
  name        = "AWS Networking labs - 01. VPC"
  space       = data.spacelift_current_space.this.id
  labels      = local.labels
  state       = "PUBLISHED"
  description = file("${path.module}/01-vpc/README.md")

  template = replace(
    replace(
      file("${path.module}/01-vpc/blueprint.yaml"),
      "$SPACE_ID",
      data.spacelift_current_space.this.id,
    ),
    "$CONTEXT_ID",
    spacelift_context.networking-labs.id,
  )
}

resource "spacelift_blueprint" "lesson-02-subnets" {
  name        = "AWS Networking labs - 02. Subnets"
  space       = data.spacelift_current_space.this.id
  labels      = local.labels
  state       = "PUBLISHED"
  description = file("${path.module}/02-subnets/README.md")


  template = replace(
    replace(
      file("${path.module}/02-subnets/blueprint.yaml"),
      "$SPACE_ID",
      data.spacelift_current_space.this.id,
    ),
    "$CONTEXT_ID",
    spacelift_context.networking-labs.id,
  )
}

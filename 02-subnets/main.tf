data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

locals {
  public_cidr_block  = cidrsubnet(data.aws_vpc.main.cidr_block, 2, 1)
  private_cidr_block = cidrsubnet(data.aws_vpc.main.cidr_block, 2, 0)
}

# For each of the availability zones, create a public subnet.
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(local.public_cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

# For each of the availability zones, create a private subnet.
resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(local.private_cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}

# Export private subnet IDs as an output and the Spacelift environment variable.
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

resource "spacelift_environment_variable" "private_subnet_ids" {
  context_id = var.shared_context_id
  name       = "TF_VAR_private_subnet_ids"
  value      = jsonencode(aws_subnet.private[*].id)
  write_only = false
}

# Export public subnet IDs as an output and the Spacelift environment variable.
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

resource "spacelift_environment_variable" "public_subnet_ids" {
  context_id = var.shared_context_id
  name       = "TF_VAR_public_subnet_ids"
  value      = jsonencode(aws_subnet.public[*].id)
  write_only = false
}


"provider" "aws" {
  region="${var.aws_region}"
  profile="${var.aws_profile}"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  vpc_keypair = "${coalesce(var.vpc_keypair, "${var.environment}-${var.name-prefix}-core")}"
}
data "aws_availability_zones" "zones" {}






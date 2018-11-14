
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



#terraform init -backend-config="bucket=poc-cog-tfstate" -backend-config="key=ec2/ec2.tfstate" -backend-config="region=us-gov-west-1" -backend-config="profile=cognosante"
#terraform remote config -backend=S3 -backend-config="bucket=terraform-poc-state" -backend-config="key=vpc/vpc.tfstate" -backend-config="region=us-gov-west-1"

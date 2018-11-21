terraform {
  backend "s3" {
    acl     = "bucket-owner-full-control"
    encrypt = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket     = "${var.remote-state-bucket-name}"
    key        = "${var.terraform-remote-state-vpc-key}"
    region     = "${data.aws_region.current.id}"
    profile    = "${var.aws_profile}"
    encrypt    = true
  }
}

#terraform init -backend-config="bucket=poc-cog-tfstate" -backend-config="key=infra/infra.tfstate" -backend-config="region=us-gov-west-1" -backend-config="profile=cognosante"


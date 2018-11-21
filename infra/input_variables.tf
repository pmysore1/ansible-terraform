variable "remote-state-bucket_name" {}
variable "terraform-remote-state-vpc-key" {}
variable "aws_region" {}
variable "aws_profile" {}
variable "environment" {}
variable "name-prefix" {}
variable "aws_ec2_user" {}

variable "vpc_keypair" {}

variable "dhcp-domain-name" {
  "type" = "string"
  "default" = "us-gov-west-1.compute.internal"
}
variable "vpc_cidr_block" {
  "type" = "string"
  "default" = "10.0.0.0/20"
}

variable "max_subnet_count" {
  default     = 0
  description = "Sets the maximum amount of subnets to deploy.  0 will deploy a subnet for every availablility zone within the region"
}

variable "az_count" {
  default     = 2
  description = "Sets the maximum number of Availability zone to use.  0 will deploy a subnet for every availablility zone within the region"
}

variable "availability_zones" {
  type        = "list"
  description = "List of Availability Zones where subnets will be created"
  default     = ["us-gov-west-1a", "us-gov-west-1b"]
}

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT gateways for private subnets"
  default     = "true"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`Cluster`,`XYZ`)"
}

variable "creater" {}

variable "required_igw" {
  default     = 1
  description = "Flag to configure Internet Gateway"
}

# Optional Bastion feature.
variable "bastion_instance" {
  default = 1
} # Change to 0 to disable the bastion.

variable "bastion_use_public_ip" {
  default = 1
} # Change to 0 to disable using an EIP for the bastion.

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "expiration_date" {
  default = ""
}
variable "dns_support" {
  default = true
}


# Remote access
variable "ssh_remote_cidr_block" {
  default = ""
}

variable "https_remote_cidr_block" {
  default = ""
}

variable "rdp_remote_cidr_block" {
  default = ""
}

variable "winrm_remote_cidr_block" {
  default = ""
}

variable "vpn_remote_cidr_block" {
  default = ""
}


# Base AMI to use for hardened RHEL7 instances
variable "baseos_rhel7_ami_id" {
  default = "ami-906cf0f1"
}

variable "baseos_ec2_ami_id" {}
  
variable "ec2_instance_type" {}

variable "s3_pem_file_path" {}
variable "s3_pem_file_name" {}

"variable" "remote-state-bucket_name" {
  "type" = "string"
  #"default" = "terraform-poc-state"
  "default" = "poc-cog-tfstate"
}
"variable" "terraform-remote-state-vpc-key" {
  "type" = "string"
  "default" = "vpc/vpc.tfstate"
}

"variable" "environment" {
  "type" = "string"
  "default" = "POC"
}

"variable" "public-az3-cidr" {
  "type" = "string"
  "default" = "10.0.2.0/24"
}
"variable" "database-az1-cidr" {
  "type" = "string"
  "default" = "10.0.8.0/24"
}
"variable" "unique_id" {
  "type" = "string"
  "default" = "ffd025"
}
"variable" "private-az2-cidr" {
  "type" = "string"
  "default" = "10.0.5.0/24"
}
"variable" "database-az2-cidr" {
  "type" = "string"
  "default" = "10.0.9.0/24"
}
"variable" "name-prefix" {
  "type" = "string"
  #"default" = "capgemini-gs-poc"
  "default" = "cognosante-poc"
}
"variable" "public-az1-cidr" {
  "type" = "string"
  "default" = "10.0.0.0/24"
}
"variable" "aws_region" {
  "type" = "string"
  "default" = "us-gov-west-1"
}
"variable" "aws_profile" {
  "type" = "string"
  "default" = "cognosante"
}
"variable" "private-az1-cidr" {
  "type" = "string"
  "default" = "10.0.4.0/24"
}
"variable" "public-az2-cidr" {
  "type" = "string"
  "default" = "10.0.1.0/24"
}
"variable" "dhcp-domain-name" {
  "type" = "string"
  "default" = "us-gov-west-1.compute.internal"
}
"variable" "database-az3-cidr" {
  "type" = "string"
  "default" = "10.0.10.0/24"
}
"variable" "vpc_cidr_block" {
  "type" = "string"
  "default" = "10.0.0.0/20"
}
"variable" "private-az3-cidr" {
  "type" = "string"
  "default" = "10.0.6.0/24"
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

variable "creater" {
  type        = "string"
  default     = "pradeep.mysore"
  description = "Additional tags (e.g. map(`Cluster`,`XYZ`)"
}

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
  default = "173.67.205.219/32,66.102.238.226/32"
}

variable "https_remote_cidr_block" {
  default = "173.67.205.219/32,66.102.238.226/32"
}

variable "rdp_remote_cidr_block" {
  default = "173.67.205.219/32,66.102.238.226/32"
}

variable "winrm_remote_cidr_block" {
  default = "173.67.205.219/32,66.102.238.226/32"
}

variable "vpn_remote_cidr_block" {
  default = "173.67.205.219/32,66.102.238.226/32"
}

variable "vpc_keypair" {
  #default = "capgemini-gs-poc-keypair"
  default = "poc-anisble-tower"
}

# Base AMI to use for hardened RHEL7 instances
variable "baseos_rhel7_ami_id" {
  default = "ami-906cf0f1"
}

variable "baseos_ec2_ami_id" {
  default = "ami-906cf0f1"
  #default = "ami-77199016"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}
variable "s3_pem_file_path" {
  default = "s3://poc-cog-tfstate/auth"
}
variable "s3_pem_file_name" {
  default = "poc-anisble-tower-cognosante.pem"
}
variable "aws_ec2_user" {
  default = "ec2-user"
}
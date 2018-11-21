remote-state-bucket_name = "poc-cog-tfstate"
terraform-remote-state-vpc-key = "vpc/vpc.tfstate"
aws_region = "us-gov-west-1"
aws_profile = "cognosante"

# Following values are used in tagging aws-resources
environment = "POC"
name-prefix = "cognosante-poc"
creater = "pradeep.mysore"

vpc_keypair= "poc-anisble-tower"
baseos_ec2_ami_id = "ami-906cf0f1"
ec2_instance_type = "t2.micro"
aws_ec2_user        = "ec2-user"
vpc_keypair         = "poc-anisble-tower"

s3_pem_file_path        = "s3://poc-cog-tfstate/auth"
s3_pem_file_name        = "poc-anisble-tower-cognosante.pem"

#following values for controlling access to AWD resources
ssh_remote_cidr_block = "173.67.205.219/32,66.102.238.226/32"
https_remote_cidr_block = "173.67.205.219/32,66.102.238.226/32"
rdp_remote_cidr_block = "173.67.205.219/32,66.102.238.226/32"
winrm_remote_cidr_block = "173.67.205.219/32,66.102.238.226/32"
vpn_remote_cidr_block  = "173.67.205.219/32,66.102.238.226/32"

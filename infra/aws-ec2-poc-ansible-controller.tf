

data "template_file" "install-ec2-ansible-controller-userdata" {
  
  template = "${file("${path.module}/templates/prepare_ansible_env.tpl")}"

  vars {
    s3_pem_file_path = "${var.s3_pem_file_path}"
    s3_pem_file_name = "${var.s3_pem_file_name}"
    aws_ec2_user = "${var.aws_ec2_user}"
  }

}

"resource" "aws_security_group" "ec2-ansible-controller-sg" {
  "vpc_id" = "${data.terraform_remote_state.vpc.vpc_id}"
  "name" = "${var.name-prefix}-ec2-ansible-controller-sg"

   "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-ec2-ansible-controller-sg"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "ansible"
    "Tier"              = "DevOps"
    }

  "ingress" = {
    "from_port" = 80
    "to_port" = 80
    "protocol" = "tcp"
    "security_groups" = ["${aws_security_group.ec2-nginx-sg.id}"]
  }


  "egress" = {
    "from_port" = 0
    "to_port" = 0
    "protocol" = "-1"
    "cidr_blocks" = ["0.0.0.0/0"]
  }
}

"resource" "aws_iam_instance_profile" "ec2-ansible-controller-instance-profile" {
  "role" = "${aws_iam_role.ec2-ansible-controller-role.name}"
  "name" = "${var.name-prefix}-ec2-anscontroller-instance-profile"
}

"resource" "aws_iam_policy_attachment" "ec2-ansible-controller-policy-attach" {
  "policy_arn" = "${aws_iam_policy.ec2-ansible-controller-policy.arn}"
  "roles" = ["${aws_iam_role.ec2-ansible-controller-role.name}"]
  "name" = "${var.name-prefix}-ec2-anscontroller-policy-attach"
}

"resource" "aws_iam_policy_attachment" "ec2-ansible-describe-policy-attach" {
  "policy_arn" = "${aws_iam_policy.ansible-describe-policy.arn}"
  "roles" = ["${aws_iam_role.ec2-ansible-controller-role.name}"]
  "name" = "${var.name-prefix}-ec2-anscontroller-describe-policy-attach"
}


"resource" "aws_iam_policy" "ec2-ansible-controller-policy" {
  "path" = "/"
  "name" = "${var.name-prefix}-ec2-anscontroller-policy"
  "policy" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Effect\": \"Allow\",\n            \"Action\": \"s3:GetObject\",\n            \"Resource\": \"arn:aws-us-gov:s3:::poc-cog-tfstate/auth/poc-anisble-tower-cognosante.pem\"\n        }\n    ]\n}"
}
"resource" "aws_iam_policy" "ansible-describe-policy" {
  "path" = "/"
  "name" = "${var.name-prefix}-anscontroller-policy"
  "policy" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Effect\": \"Allow\",\n            \"Action\": \"ec2:Describe*\",\n            \"Resource\": \"*\"\n        }\n    ]\n}"
}


"resource" "aws_iam_role" "ec2-ansible-controller-role" {
  "name" = "${var.name-prefix}-ec2-anscontroller-role"
  "assume_role_policy" = "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}"
}


"resource" "aws_instance" "ec2-ansible-controller-az1" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-anscontroller-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-ansible-controller-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 0)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-ansible-controller-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-ansible-controller-${element(data.aws_availability_zones.zones.names, 0)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "ansible-controller"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}

"resource" "aws_instance" "ec2-ansible-controller-az2" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-anscontroller-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-ansible-controller-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 1)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-ansible-controller-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-ansible-controller-${element(data.aws_availability_zones.zones.names, 1)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "ansible-controller"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}

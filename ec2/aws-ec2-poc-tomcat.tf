

data "template_file" "install-ec2-tomcat-userdata" {
  
  template = "${file("${path.module}/templates/install_common_tools.tpl")}"

}

"resource" "aws_security_group" "ec2-tomcat-sg" {
  "vpc_id" = "${data.terraform_remote_state.vpc.vpc_id}"
  "name" = "${var.name-prefix}-ec2-tomcat-sg"

   "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-ec2-tomcat-sg"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "DevOps"
    "Tier"              = "DevOps"
    }

  "ingress" = {
    "from_port" = 8080
    "to_port" = 8080
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

"resource" "aws_iam_instance_profile" "ec2-tomcat-instance-profile" {
  "role" = "${aws_iam_role.ec2-tomcat-role.name}"
  "name" = "${var.name-prefix}-ec2-tomcat-instance-profile"
}

"resource" "aws_iam_policy_attachment" "ec2-tomcat-policy-attach" {
  "policy_arn" = "${aws_iam_policy.ec2-tomcat-policy.arn}"
  "roles" = ["${aws_iam_role.ec2-tomcat-role.name}"]
  "name" = "${var.name-prefix}-ec2-tomcat-policy-attach"
}

"resource" "aws_iam_policy" "ec2-tomcat-policy" {
  "path" = "/"
  "name" = "${var.name-prefix}-ec2-tomcat-policy"
  "policy" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Effect\": \"Allow\",\n            \"Action\": \"s3:GetObject\",\n            \"Resource\": \"*\"\n        }\n    ]\n}"
}

"resource" "aws_iam_role" "ec2-tomcat-role" {
  "name" = "${var.name-prefix}-ec2-tomcat-role"
  "assume_role_policy" = "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}"
}


"resource" "aws_instance" "ec2-tomcat-az1" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-tomcat-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-tomcat-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 0)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-tomcat-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-tomcat-${element(data.aws_availability_zones.zones.names, 0)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "tomcat"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}

"resource" "aws_instance" "ec2-tomcat-az2" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-tomcat-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-tomcat-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 1)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-tomcat-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-tomcat-${element(data.aws_availability_zones.zones.names, 1)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "tomcat"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}

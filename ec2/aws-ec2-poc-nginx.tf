

data "template_file" "install-ec2-nginx-userdata" {
  
  template = "${file("${path.module}/templates/install_common_tools.tpl")}"

}

"resource" "aws_security_group" "ec2-nginx-sg" {
  "vpc_id" = "${data.terraform_remote_state.vpc.vpc_id}"
  "name" = "${var.name-prefix}-ec2-nginx-sg"

   "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-ec2-nginx-sg"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "DevOps"
    "Tier"              = "DevOps"
    }

  "ingress" = {
    "from_port" = 80
    "to_port" = 80
    "protocol" = "tcp"
    "security_groups" = ["${aws_security_group.alb-remote-access.id}"]
  }


  "egress" = {
    "from_port" = 0
    "to_port" = 0
    "protocol" = "-1"
    "cidr_blocks" = ["0.0.0.0/0"]
  }
}

"resource" "aws_iam_instance_profile" "ec2-nginx-instance-profile" {
  "role" = "${aws_iam_role.ec2-nginx-role.name}"
  "name" = "${var.name-prefix}-ec2-nginx-instance-profile"
}

"resource" "aws_iam_policy_attachment" "ec2-nginx-policy-attach" {
  "policy_arn" = "${aws_iam_policy.ec2-nginx-policy.arn}"
  "roles" = ["${aws_iam_role.ec2-nginx-role.name}"]
  "name" = "${var.name-prefix}-ec2-nginx-policy-attach"
}

"resource" "aws_iam_policy" "ec2-nginx-policy" {
  "path" = "/"
  "name" = "${var.name-prefix}-ec2-nginx-policy"
  "policy" = "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Effect\": \"Allow\",\n            \"Action\": \"s3:GetObject\",\n            \"Resource\": \"*\"\n        }\n    ]\n}"
}

"resource" "aws_iam_role" "ec2-nginx-role" {
  "name" = "${var.name-prefix}-ec2-nginx-role"
  "assume_role_policy" = "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}"
}


"resource" "aws_instance" "ec2-nginx-az1" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-nginx-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-nginx-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 0)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-nginx-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-nginx-${element(data.aws_availability_zones.zones.names, 0)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "nginx"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}

"resource" "aws_instance" "ec2-nginx-az2" {
  "count" = 1
  "key_name" = "${var.vpc_keypair}"
  "iam_instance_profile" = "${var.name-prefix}-ec2-nginx-instance-profile"
  "vpc_security_group_ids" = ["${aws_security_group.ec2-nginx-sg.id}", "${data.terraform_remote_state.vpc.ssh_remote_access_sg}"]
  "instance_initiated_shutdown_behavior" = "stop"
  "subnet_id" = "${element(data.terraform_remote_state.vpc.private_subnet_ids, 1)}"
  #"depends_on" = ["aws_nat_gateway.nat"]
  
  "user_data" = <<EOF
        ${data.template_file.install-ec2-nginx-userdata.rendered}
    EOF

  "ami" = "${var.baseos_ec2_ami_id}"
  "source_dest_check" = true
  "instance_type" = "${var.ec2_instance_type}"
 "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-nginx-${element(data.aws_availability_zones.zones.names, 1)}-${count.index}"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "nginx"
    "Tier"              = "DevOps"
    }
  "root_block_device" = {
    "volume_type" = "standard"
    "volume_size" = "40"
    "delete_on_termination" = "true"
  }
}


resource "aws_lb" "load-balancer" {
  name               = "${var.name-prefix}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb-remote-access.id}","${aws_security_group.ec2-nginx-sg.id}"]
  subnets            = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]

  "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-nginx-load-balancer"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "DevOps"
    "Tier"              = "DevOps"
    }
}

resource "aws_lb_target_group" "ec2-http" {
  name     = "${var.name-prefix}-alb-http"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"
}
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = "${aws_lb.load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ec2-http.arn}"
  }
}


resource "aws_lb_target_group" "ec2-https" {
  name     = "${var.name-prefix}-alb-https"
  port     = 433
  protocol = "HTTPS"
  target_type = "instance"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_lb_target_group_attachment" "ec2-https-az1" {
  target_group_arn = "${aws_lb_target_group.ec2-https.arn}"
  target_id        = "${aws_instance.ec2-nginx-az1.0.id}"
  port             = 443
}

resource "aws_lb_target_group_attachment" "ec2-http-az1" {
  count            = 1
  target_group_arn = "${aws_lb_target_group.ec2-http.arn}"
  target_id        = "${element(aws_instance.ec2-nginx-az1.*.id, count.index)}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2-http-az2" {
  count            = 1
  target_group_arn = "${aws_lb_target_group.ec2-http.arn}"
  target_id        = "${element(aws_instance.ec2-nginx-az2.*.id, count.index)}"
  port             = 80
}


resource "aws_security_group" "alb-remote-access" {
  count       = "${length(var.ssh_remote_cidr_block) > 0 ? 1 : 0}"
  name        = "${var.environment}-${var.name-prefix}-alb-nginx-remote-access-sg"
  description = "Remote access for HTTP"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

 
   "tags" = {
    "CreatedBy"         = "${var.creater}"
    "Name"              = "${var.name-prefix}-alb-nginx-remote-access-sg"
    "Environment"       = "${var.environment}"
    "Application"       = "${var.name-prefix}"
    "Role"              = "Network"
    "Tier"              = "Network"
    }
}

resource "aws_security_group_rule" "alb-remote-access" {
  count             = "${length(var.https_remote_cidr_block) > 0 ? 1 : 0}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.alb-remote-access.0.id}"
  cidr_blocks       = ["${split(",",var.https_remote_cidr_block)}"]
  description       = "Remote access for HTTP"
}

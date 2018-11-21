

output "az_count" {
  value = "${var.az_count}"
}

output "ec2_nginx_private_ip-az1" {
  value = ["${aws_instance.ec2-nginx-az1.*.private_ip}"]
}
output "ec2_nginx_private_ip-az2" {
  value = ["${aws_instance.ec2-nginx-az2.*.private_ip}"]
}

output "ec2_tomcat_private_ip-az1" {
  value = ["${aws_instance.ec2-tomcat-az1.*.private_ip}"]
}
output "ec2_tomcat_private_ip-az2" {
  value = ["${aws_instance.ec2-tomcat-az2.*.private_ip}"]
}

output "ec2_django_private_ip-az1" {
  value = ["${aws_instance.ec2-django-az1.*.private_ip}"]
}
output "ec2_django_private_ip-az2" {
  value = ["${aws_instance.ec2-django-az2.*.private_ip}"]
}

# RDS related outputs


output "db_instance_id" {
  value = "${ join(" ", aws_db_instance.mysql.*.id) }"
}

output "db_endpoint" {
  value = "${ join(" ", aws_db_instance.mysql.*.endpoint) }"
}

output "db_address" {
  value = "${ join(" ", aws_db_instance.mysql.*.address) }"
}

output "db_root_name" {
  value = "${ join(" ", aws_db_instance.mysql.*.name) }"
}

output "db_root_username" {
  value = "${ join(" ", aws_db_instance.mysql.*.username) }"
}

output "db_root_password" {
  sensitive = true
  value     = "${ join(" ", aws_db_instance.mysql.*.password) }"
}

output "client_sg_id" {
  value = "${aws_security_group.mysql-client.id}"
}
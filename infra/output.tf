

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
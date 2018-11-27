"resource" "aws_db_instance" "mysql" {
  "allocated_storage" = "${var.db_size}"

  "backup_retention_period" = "${var.db_backup_retention_period}"

  "backup_window" = "${var.db_backup_window}"

  "copy_tags_to_snapshot" = true


  "db_subnet_group_name" = "${aws_db_subnet_group.mysql.id}"

  "engine" = "mysql"

  "engine_version" = "${var.db_engine_version}"

  "final_snapshot_identifier" = "${lower(var.environment)}-${lower(var.name-prefix)}-mysql-${uuid()}"

  "identifier" = "${lower(var.environment)}-${lower(var.name-prefix)}-mysql"

  "instance_class" = "${var.db_instance_class}"

  #"kms_key_id" = "${data.terraform_remote_state.iam.rds_kms_key_arn}"

  "lifecycle" = {
    "ignore_changes" = ["snapshot_identifier", "final_snapshot_identifier"]

    "prevent_destroy" = false
  }

  "maintenance_window" = "${var.db_maintenance_window}"

  "multi_az" = "${var.db_multi_az}"

  "name" = "${var.db_name}"

  "password" = "${var.db_password}"

  "snapshot_identifier" = "${var.db_snapshot_identifier}"

  "storage_encrypted" = true

  "tags" = {
    "Environment" = "${var.environment}"

    "ExpirationDate" = "${var.expiration_date}"

    "Name" = "${var.environment}-${var.name-prefix}-MySQL"

    "Product" = "${var.product}"
    Application        = "${var.name-prefix}"
    Role                = "RDS"
  }

  "username" = "${var.db_username}"

  "vpc_security_group_ids" = ["${aws_security_group.mysql.id}"]
}


resource "aws_security_group" "mysql-client" {
  name        = "${var.environment}-${var.name-prefix}-MySQL-client"
  description = "Access to MySQL DB for POC"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name           = "${var.environment}-${var.name-prefix}-MySQL-client"
    Environment    = "${var.environment}"
    creater          = "${var.creater}"
    Application        = "${var.name-prefix}"
    Product        = "${var.product}"
    ExpirationDate = "${var.expiration_date}"
  }
}

"resource" "aws_security_group" "mysql" {

  "description" = "Access to POC Platform MySQL"

  "ingress" = {
    "from_port" = 3306

    "protocol" = "tcp"

    "security_groups" = ["${aws_security_group.mysql-client.id}"]

    "to_port" = 3306
  }

  "name" = "${var.environment}-${var.name-prefix}-MySQL"

  "tags" = {
    "Environment" = "${var.environment}"

    "ExpirationDate" = "${var.expiration_date}"

    "Name" = "${var.environment}-${var.name-prefix}-MySQL"

    "Product" = "${var.product}"

    Application        = "${var.name-prefix}"
  }

  "vpc_id" = "${data.terraform_remote_state.vpc.vpc_id}"
}

"resource" "aws_db_subnet_group" "mysql" {

  "name" = "${lower(var.environment)}-${lower(var.name-prefix)}-mysql"

  #"subnet_ids" = ["${split(",", data.terraform_remote_state.vpc.private_subnet_ids)}"]
  "subnet_ids" = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]

  "tags" = {
    "Environment" = "${var.environment}"

    "Name" = "${var.environment}-${var.name-prefix}-MySQL"

    "Product" = "${var.product}"

    Application        = "${var.name-prefix}"
  }
}

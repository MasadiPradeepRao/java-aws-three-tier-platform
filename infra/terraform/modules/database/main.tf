data "aws_rds_engine_version" "mysql" {
  engine  = "mysql"
  version = "8.4"
  latest  = true
}

resource "aws_db_subnet_group" "database" {
  name       = "${var.project_name}-${var.environment}-database"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-database"
  }
}

resource "aws_db_instance" "database" {
  identifier                  = "${var.project_name}-${var.environment}"
  engine                      = "mysql"
  engine_version              = data.aws_rds_engine_version.mysql.version
  instance_class              = var.instance_class
  allocated_storage           = 20
  max_allocated_storage       = 100
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = "access_portal"
  username                    = var.master_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.database.name
  vpc_security_group_ids      = [var.database_security_group_id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 1
  auto_minor_version_upgrade  = true
  deletion_protection         = false
  skip_final_snapshot         = true
  apply_immediately           = false

  tags = {
    Name = "${var.project_name}-${var.environment}-database"
  }
}

resource "aws_secretsmanager_secret" "application_database" {
  name                    = "${var.project_name}/${var.environment}/database/application"
  description             = "Least-privilege database credentials used by the access portal."
  recovery_window_in_days = 0
}

data "aws_vpc" "selected_vpc" {
  id = var.vpc_id  # Get the VPC ID passed from the root module
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  subnet_ids  = var.private_subnets  # Use private subnets from VPC
  description = "RDS subnet group"
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = var.storage_type
  identifier             = "${var.environment}-rds"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.db_user
  password               = var.db_password
  # db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_security_group]
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  snapshot_identifier    = var.snapshot_identify  # If restoring from a snapshot
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true


  tags = {
    Name        = "${var.environment}-rds"
    Environment = var.environment
  }
}


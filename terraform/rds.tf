# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_db_instance" "body-record-db" {
  allocated_storage                     = 20
  allow_major_version_upgrade           = null
  auto_minor_version_upgrade            = true
  availability_zone                     = "us-east-1a"
  backup_retention_period               = 1
  backup_target                         = "region"
  backup_window                         = "07:57-08:27"
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"
  character_set_name                    = null
  copy_tags_to_snapshot                 = true
  custom_iam_instance_profile           = null
  customer_owned_ip_enabled             = false
  db_name                               = null
  db_subnet_group_name                  = "default-vpc-0a5d8dd2f75850a61"
  dedicated_log_volume                  = false
  delete_automated_backups              = true
  deletion_protection                   = false
  domain                                = null
  domain_auth_secret_arn                = null
  domain_fqdn                           = null
  domain_iam_role_name                  = null
  domain_ou                             = null
  enabled_cloudwatch_logs_exports       = []
  engine                                = "postgres"
  engine_version                        = jsonencode(16.1)
  final_snapshot_identifier             = null
  iam_database_authentication_enabled   = false
  identifier                            = "database-1"
  identifier_prefix                     = null
  instance_class                        = "db.t3.micro"
  iops                                  = 0
  kms_key_id                            = "arn:aws:kms:us-east-1:110550326393:key/10d0f8d3-a669-4498-abcb-22ce86c1cd5b"
  license_model                         = "postgresql-license"
  maintenance_window                    = "sun:08:46-sun:09:16"
  manage_master_user_password           = null
  master_user_secret_kms_key_id         = null
  max_allocated_storage                 = 1000
  monitoring_interval                   = 0
  monitoring_role_arn                   = null
  multi_az                              = false
  nchar_character_set_name              = null
  network_type                          = "IPV4"
  option_group_name                     = "default:postgres-16"
  parameter_group_name                  = "default.postgres16"
  password                              = null # sensitive
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:us-east-1:110550326393:key/10d0f8d3-a669-4498-abcb-22ce86c1cd5b"
  performance_insights_retention_period = 7
  port                                  = 5432
  publicly_accessible                   = false
  replica_mode                          = null
  replicate_source_db                   = null
  skip_final_snapshot                   = true
  snapshot_identifier                   = null
  storage_encrypted                     = true
  storage_throughput                    = 0
  storage_type                          = "gp2"
  tags                                  = {}
  tags_all                              = {}
  timezone                              = null
  username                              = data.aws_ssm_parameter.db_username.value
  vpc_security_group_ids                = ["sg-05f85a822bf4fef78"]
}

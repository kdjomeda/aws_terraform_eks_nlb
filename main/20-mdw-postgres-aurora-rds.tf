# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "${local.common_name}-postgres-mdw-subgroup"
#   subnet_ids = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
# }
#
# resource "aws_security_group" "postgres_secgroup" {
#   name   = "${local.common_name}-postgres-sg"
#   vpc_id = aws_vpc.main.id
#
#   # Allow inbound traffic from EKS pods
#   ingress {
#     from_port   = var.var_rds_aurora_db_port
#     to_port     = var.var_rds_aurora_db_port
#     protocol    = "tcp"
#     #     security_groups = [aws_security_group.e.id] # Security group for the EKS pods
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# module "rds_aurora" {
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   name = "${local.common_name}-mdw-db"
#   engine = var.var_rds_aurora_engine
#   engine_version = var.var_rds_aurora_engine_version
#   instances = {
#     1 = {
#       identifier   = "${local.common_name}-mdw-db-1"
#       instance_class = var.var_rds_aurora_first_instance_class
#       publicly_accessible = var.var_rds_aurora_first_publicly_accessible
#     }
#     2 = {
#       identifier   = "${local.common_name}-mdw-db-2"
#       instance_class = var.var_rds_aurora_second_instance_class
#       publicly_accessible = var.var_rds_aurora_second_publicly_accessible
#     }
#   }
#
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
#   create_db_subnet_group = var.var_rds_aurora_create_db_subnet_group
#
#   create_db_parameter_group      = var.var_rds_aurora_create_db_param_group
#   db_parameter_group_name = var.var_rds_aurora_postgres_15_8_paramgroup_name
#   db_parameter_group_family = var.var_rds_aurora_postgres_15_8_paramgroup_family                       ///"aurora-postgresql14"
#   db_parameter_group_description = "${local.common_name} parameter group"
#   db_parameter_group_parameters = [
#     {
#       name         = "log_min_duration_statement"
#       value        = 4000
#       apply_method = "immediate"
#     }
#   ]
#   db_cluster_parameter_group_name = var.var_rds_aurora_cluster_postgres_15_8_paramgroup_name
#   engine_lifecycle_support = "open-source-rds-extended-support-disabled"
#
#   create_db_cluster_parameter_group      = var.var_rds_aurora_create_db_cluster_param_group
#   db_cluster_parameter_group_family      = var.var_rds_aurora_cluster_postgres_15_8_paramgroup_family //"aurora-postgresql14"
#   db_cluster_parameter_group_description = "${local.common_name} example cluster parameter group"
#   db_cluster_parameter_group_parameters = [
#     {
#       name         = "log_min_duration_statement"
#       value        = 4000
#       apply_method = "immediate"
#     }
#   ]
#
#   vpc_id = aws_vpc.main.id
#
#   create_security_group = var.var_rds_aurora_create_security_group
#   iam_database_authentication_enabled = var.var_rds_aurora_iam_authentication_enable
#   master_password = var.var_rds_aurora_master_password
#   master_username = var.var_rds_aurora_master_username
#   database_name   = var.var_rds_aurora_database_name
#   apply_immediately = var.var_rds_aurora_apply_immediately
#   skip_final_snapshot = var.var_rds_aurora_skip_final_snapshot
#
#   enabled_cloudwatch_logs_exports = var.var_rds_aurora_cloudwatch_logs_exports
#   vpc_security_group_ids = [aws_security_group.postgres_secgroup.id]
#   port                   = var.var_rds_aurora_db_port
#   tags = {
#     Terraform = true
#     Name = "${local.common_name}-mdw-db"
#     ENV = var.var_rds_aurora_environment
#   }
# }
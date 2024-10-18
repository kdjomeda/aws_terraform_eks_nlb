profile = "joseph"


# var_pg_rds_main_dbname = "middleware_db"

var_forti_ha_sync_zone1 = "10.0.128.0/24"
var_forti_ha_sync_zone2 = "10.0.129.0/24"
var_forti_ha_mgmt_zone1 = "10.0.130.0/24"
var_forti_ha_mgmt_zone2 = "10.0.131.0/24"

var_vpc_name = "vpc-act01"
var_igw_name = "igw-act01"
var_private_zone1_cidr = "10.0.0.0/19"
var_private_zone2_cidr = "10.0.32.0/19"
var_public_zone1_cidr = "10.0.64.0/19"
var_public_zone2_cidr = "10.0.96.0/19"
var_nat_name = "nat-act01"
var_office_ips = ["41.155.68.45/32"]

# var_rds_aurora_identifier = ""
var_rds_aurora_engine = "aurora-postgresql"
var_rds_aurora_engine_version = "15.8"
# var_rds_aurora_first_instance_identifier = ""
var_rds_aurora_first_instance_class = "db.t3.medium"
var_rds_aurora_first_publicly_accessible = false
# var_rds_aurora_second_instance_identifier = ""
var_rds_aurora_second_instance_class = "db.t3.medium"
var_rds_aurora_second_publicly_accessible = false
var_rds_aurora_create_db_subnet_group = false
var_rds_aurora_postgres_15_8_paramgroup_name = "gmfs-ire-prod-postgres15-8-pgroup"
var_rds_aurora_postgres_15_8_paramgroup_family = "aurora-postgresql15"
var_aurora_cluster_postgres_15_8_paramgroup_name = "gmfs-ire-prod-postgres15-8-cluster-pgroup"
var_rds_aurora_create_db_param_group = true
var_rds_aurora_create_db_cluster_param_group = true
var_aurora_cluster_postgres_15_8_paramgroup_family = "aurora-postgresql15"
var_rds_aurora_create_security_group = true
var_rds_aurora_iam_authentication_enable = true
# var_rds_aurora_master_password = ""
# var_rds_aurora_master_username = ""
var_rds_aurora_database_name = "gmfsireprodmdwdb"
var_rds_aurora_apply_immediately = true
var_rds_aurora_skip_final_snapshot = true
var_rds_aurora_cloudwatch_logs_exports = ["postgresql"]
# var_rds_aurora_vpc_security_group_ids_list = ""
var_rds_aurora_db_port = "5432"
var_rds_aurora_product_name = "gmfs-ire-prod-mdw"
var_rds_aurora_environment = "prod"

var_iam_ec2_role_name = "bastion-role"
var_iam_ec2_profile_name = "bastion-profile"
var_iam_ec2_ec2_session_manager_ssm_policy_name = "bastion-policy"
var_ec2instance_ami_id = "ami-0a422d70f727fe93e"
var_ec2instance_instance_class = "t3.small"
var_ec2instance_ssh_key_name = "OTPersonal.pem"
var_ec2instance_should_enable_public_ip = true
var_ec2instance_private_ips_list = ["10.0.64.15","10.0.96.15"]
var_ec2instance_count = 1
var_ec2instance_should_root_block_encrypted = true
var_ec2instance_name = "bastion-host"
var_ec2instance_root_ebs_volume_size = "30"
var_ec2instance_root_ebs_volume_type = "gp3"
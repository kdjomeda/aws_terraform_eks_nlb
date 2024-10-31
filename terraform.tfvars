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
var_rds_aurora_cluster_postgres_15_8_paramgroup_name = "gmfs-ire-prod-postgres15-8-cluster-pgroup"
var_rds_aurora_create_db_param_group = true
var_rds_aurora_create_db_cluster_param_group = true
var_rds_aurora_cluster_postgres_15_8_paramgroup_family = "aurora-postgresql15"
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

# var_core_rds_aurora_identifier = ""
var_core_rds_aurora_engine = "aurora-postgresql"
var_core_rds_aurora_engine_version = "15.8"
# var_core_rds_aurora_first_instance_identifier = ""
var_core_rds_aurora_first_instance_class = "db.t3.medium"
var_core_rds_aurora_first_publicly_accessible = false
# var_core_rds_aurora_second_instance_identifier = ""
var_core_rds_aurora_second_instance_class = "db.t3.medium"
var_core_rds_aurora_second_publicly_accessible = false
var_core_rds_aurora_create_db_subnet_group = false
var_core_rds_aurora_postgres_15_8_paramgroup_name = "gmfs-ire-prod-core-postgres15-8-pgroup"
var_core_rds_aurora_postgres_15_8_paramgroup_family = "aurora-postgresql15"
var_core_rds_aurora_cluster_postgres_15_8_paramgroup_name = "gmfs-ire-prod-core-postgres15-8-cluster-pgroup"
var_core_rds_aurora_create_db_param_group = true
var_core_rds_aurora_create_db_cluster_param_group = true
var_core_rds_aurora_cluster_postgres_15_8_paramgroup_family = "aurora-postgresql15"
var_core_rds_aurora_create_security_group = true
var_core_rds_aurora_iam_authentication_enable = true
# var_core_rds_aurora_master_password = ""
# var_core_rds_aurora_master_username = ""
var_core_rds_aurora_database_name = "gmfsireprodaurthadb"
var_core_rds_aurora_apply_immediately = true
var_core_rds_aurora_skip_final_snapshot = true
var_core_rds_aurora_cloudwatch_logs_exports = ["postgresql"]
# var_core_rds_aurora_vpc_security_group_ids_list = ""
var_core_rds_aurora_db_port = "5432"
var_core_rds_aurora_product_name = "gmfs-ire-prod-core"
var_core_rds_aurora_environment = "prod"

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

var_mdw_node_group_instances_type = ["t3.small"]
var_mdw_node_group_instances_min = 1
var_mdw_node_group_instances_max = 10
var_mdw_node_group_instances_desired = 2


var_artha_node_group_instances_type = ["t3.small"]
var_artha_node_group_instances_min = 1
var_artha_node_group_instances_max = 10
var_artha_node_group_instances_desired = 2
var_cloudflare_whitelist_cidr = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/13","104.24.0.0/14","172.64.0.0/13","131.0.72.0/22"]


var_mskcluster_cluster_configuration_name = "mskconfig"
var_mskcluster_properties_auto_create = "true"
var_mskcluster_properties_replication_factor = "2"
var_mskcluster_properties_mni_insync_replicas = "2"
var_mskcluster_properties_io_thread = "10"
var_mskcluster_properties_network_thread = "8"
var_mskcluster_properties_partitions = "2"
var_mskcluster_properties_replica_fetchers = "2"
var_mskcluster_properties_replica_max_lagtime = "30000"
var_mskcluster_properties_receive_buffer_bytes = "102400"
var_mskcluster_properties_request_max_bytes = "104857600"
var_mskcluster_properties_send_buffer_bytes = "102400"
var_mskcluster_properties_unclean_leader_election = "true"
var_mskcluster_properties_session_timeout = "18000"
var_mskcluster_cluster_name = "kafka-cluster"
var_mskcluster_kafka_version = "3.6.0"
var_mskcluster_number_of_broker_nodes = "2"
var_mskcluster_msk_instance_type = "kafka.t3.small"
var_mskcluster_ebs_volume_size = "100"
var_mskcluster_encryption_info_client_broker = "PLAINTEXT"
var_mskcluster_secgroup_from_port = "9092"
var_mskcluster_secgroup_to_port = "9094"



var_redis_paramgroupfamily = "redis7"
var_redis_paramgroupname = "redis-pgroup"
var_redis_subnetgroupname = "redis-subgroup"
# var_redis_subnet_id_list = ""
var_redis_replication_group_id = "redis-rgroup"
var_redis_instance_class = "cache.t3.small"
var_redis_engine_version = "7.1"
var_redis_replica_nodes_number = "1"
var_redis_nodes_number = "1"
var_redis_port = "6379"

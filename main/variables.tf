variable "profile" {
  default = "default"
  description = "AWS profile"
}

# variable "var_pg_rds_master_username" {}
# variable "var_pg_rds_master_password" {}
# variable "var_pg_rds_main_dbname" {}

variable "var_forti_ha_sync_zone1" {}
variable "var_forti_ha_sync_zone2" {}
variable "var_forti_ha_mgmt_zone1" {}
variable "var_forti_ha_mgmt_zone2" {}

variable "var_vpc_name" {}
variable "var_igw_name" {}
variable "var_private_zone1_cidr" {}
variable "var_private_zone2_cidr" {}
variable "var_public_zone1_cidr" {}
variable "var_public_zone2_cidr" {}
variable "var_nat_name" {}
variable "var_office_ips" {
  type = list(string)
}


##From EKe
variable "kubernetes_version" {
  description = "EKS version"
  type        = string
  default     = "1.30"
}

variable "eks_admin_role_name" {
  description = "EKS admin role"
  type        = string
  default     = "gmfseksadminrole"
}

variable "addons" {
  description = "EKS addons"
  type        = any
  default = {
    enable_aws_load_balancer_controller = true
    enable_aws_argocd = false
  }
}

variable "authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are CONFIG_MAP, API or API_AND_CONFIG_MAP"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}


# variable "var_rds_aurora_identifier" {}
variable "var_rds_aurora_engine" {}
variable "var_rds_aurora_engine_version" {}
# variable "var_rds_aurora_first_instance_identifier" {}
variable "var_rds_aurora_first_instance_class" {}
variable "var_rds_aurora_first_publicly_accessible" {}
# variable "var_rds_aurora_second_instance_identifier" {}
variable "var_rds_aurora_second_instance_class" {}
variable "var_rds_aurora_second_publicly_accessible" {}
variable "var_rds_aurora_create_db_subnet_group" {}
variable "var_rds_aurora_postgres_15_8_paramgroup_name" {}
variable "var_rds_aurora_postgres_15_8_paramgroup_family" {}                       ///aurora-postgresql14
variable "var_rds_aurora_cluster_postgres_15_8_paramgroup_name" {}
variable "var_rds_aurora_create_db_param_group" {}
variable "var_rds_aurora_create_db_cluster_param_group" {}
variable "var_rds_aurora_cluster_postgres_15_8_paramgroup_family" {} //"aurora-postgresql14"" {}
variable "var_rds_aurora_create_security_group" {}
variable "var_rds_aurora_iam_authentication_enable" {}
variable "var_rds_aurora_master_password" {}
variable "var_rds_aurora_master_username" {}
variable "var_rds_aurora_database_name" {}
variable "var_rds_aurora_apply_immediately" {}
variable "var_rds_aurora_skip_final_snapshot" {}
variable "var_rds_aurora_cloudwatch_logs_exports" {}
# variable "var_rds_aurora_vpc_security_group_ids_list" {}
variable "var_rds_aurora_db_port" {}
variable "var_rds_aurora_product_name" {}
variable "var_rds_aurora_environment" {}


# variable "var_core_rds_aurora_identifier" {}
variable "var_core_rds_aurora_engine" {}
variable "var_core_rds_aurora_engine_version" {}
# variable "var_core_rds_aurora_first_instance_identifier" {}
variable "var_core_rds_aurora_first_instance_class" {}
variable "var_core_rds_aurora_first_publicly_accessible" {}
# variable "var_core_rds_aurora_second_instance_identifier" {}
variable "var_core_rds_aurora_second_instance_class" {}
variable "var_core_rds_aurora_second_publicly_accessible" {}
variable "var_core_rds_aurora_create_db_subnet_group" {}
variable "var_core_rds_aurora_postgres_15_8_paramgroup_name" {}
variable "var_core_rds_aurora_postgres_15_8_paramgroup_family" {}                       ///aurora-postgresql14
variable "var_core_rds_aurora_cluster_postgres_15_8_paramgroup_name" {}
variable "var_core_rds_aurora_create_db_param_group" {}
variable "var_core_rds_aurora_create_db_cluster_param_group" {}
variable "var_core_rds_aurora_cluster_postgres_15_8_paramgroup_family" {} //"aurora-postgresql14"" {}
variable "var_core_rds_aurora_create_security_group" {}
variable "var_core_rds_aurora_iam_authentication_enable" {}
variable "var_core_rds_aurora_master_password" {}
variable "var_core_rds_aurora_master_username" {}
variable "var_core_rds_aurora_database_name" {}
variable "var_core_rds_aurora_apply_immediately" {}
variable "var_core_rds_aurora_skip_final_snapshot" {}
variable "var_core_rds_aurora_cloudwatch_logs_exports" {}
# variable "var_core_rds_aurora_vpc_security_group_ids_list" {}
variable "var_core_rds_aurora_db_port" {}
variable "var_core_rds_aurora_product_name" {}
variable "var_core_rds_aurora_environment" {}

variable "var_iam_ec2_role_name" {}
variable "var_iam_ec2_ec2_session_manager_ssm_policy_name" {}
variable "var_ec2instance_ami_id" {}
variable "var_ec2instance_instance_class" {}
variable "var_ec2instance_ssh_key_name" {}
variable "var_ec2instance_should_enable_public_ip" {}
variable "var_ec2instance_private_ips_list" {}
variable "var_ec2instance_count" {}
variable "var_ec2instance_should_root_block_encrypted" {}
variable "var_ec2instance_name" {}
variable "var_ec2instance_root_ebs_volume_size" {}
variable "var_ec2instance_root_ebs_volume_type" {}
variable "var_iam_ec2_profile_name" {}

variable "var_mdw_node_group_instances_type" {
  type = list(string)
}
variable "var_mdw_node_group_instances_min" {}
variable "var_mdw_node_group_instances_max" {}
variable "var_mdw_node_group_instances_desired" {}

variable "var_artha_node_group_instances_type" {
  type = list(string)
}
variable "var_artha_node_group_instances_min" {}
variable "var_artha_node_group_instances_max" {}
variable "var_artha_node_group_instances_desired" {}
variable "var_cloudflare_whitelist_cidr" {
  type = list(string)
}

variable "var_mskcluster_cluster_configuration_name" {}
variable "var_mskcluster_properties_auto_create" {}
variable "var_mskcluster_properties_replication_factor" {}
variable "var_mskcluster_properties_mni_insync_replicas" {}
variable "var_mskcluster_properties_io_thread" {}
variable "var_mskcluster_properties_network_thread" {}
variable "var_mskcluster_properties_partitions" {}
variable "var_mskcluster_properties_replica_fetchers" {}
variable "var_mskcluster_properties_replica_max_lagtime" {}
variable "var_mskcluster_properties_receive_buffer_bytes" {}
variable "var_mskcluster_properties_request_max_bytes" {}
variable "var_mskcluster_properties_send_buffer_bytes" {}
variable "var_mskcluster_properties_unclean_leader_election" {}
variable "var_mskcluster_properties_session_timeout" {}
variable "var_mskcluster_cluster_name" {}
variable "var_mskcluster_kafka_version" {}
variable "var_mskcluster_number_of_broker_nodes" {}
variable "var_mskcluster_msk_instance_type" {}

variable "var_mskcluster_ebs_volume_size" {}

variable "var_mskcluster_encryption_info_client_broker" {}
variable "var_mskcluster_secgroup_from_port" {}
variable "var_mskcluster_secgroup_to_port" {}



variable "var_redis_paramgroupfamily" {}
variable "var_redis_paramgroupname" {}
variable "var_redis_subnetgroupname" {}
# variable "var_redis_subnet_id_list" {}
variable "var_redis_replication_group_id" {}
variable "var_redis_instance_class" {}
variable "var_redis_engine_version" {}
variable "var_redis_replica_nodes_number" {}
variable "var_redis_nodes_number" {}
variable "var_redis_port" {}

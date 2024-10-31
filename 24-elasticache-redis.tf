# resource "aws_security_group" "core_redis_secgroup" {
#   name        = "${local.common_name}-${local.artha_product}-redis-secgroup"
#   description = "Security Group elasticache Redis"
#   vpc_id      = aws_vpc.main.id
#
# #   ingress {
# #     from_port   = 0
# #     to_port     = 0
# #     protocol    = "icmp"
# #     #     cidr_blocks = ["41.155.68.45/32"]
# #     security_groups = [aws_security_group.forti_internal_secgroup.id]
# #     description = "Allow ICMP Access to Fortigate"
# #   }
#   ingress {
#     from_port   = var.var_redis_port
#     to_port     = var.var_redis_port
#     protocol    = "tcp"
#     security_groups = [aws_security_group.bastion_host_secgroup.id]
#     description = "Allow all from bastion host"
#   }
#
#   ingress {
#     from_port   = var.var_redis_port
#     to_port     = var.var_redis_port
#     protocol    = "tcp"
#     security_groups = [aws_security_group.eks_core_nodes_secgroup.id]
#     description = "Allow all from core esk node group"
#   }
#
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${local.common_name}-${local.artha_product}-redis-secgroup"
#     Terraform = true
#     Product = local.artha_product
#     ENV = local.env
#   }
# }
#
#
# resource "aws_elasticache_parameter_group" "redis_parameter_group" {
#   name   = "${local.common_name}-${local.artha_product}-${var.var_redis_paramgroupname}"
#   family = var.var_redis_paramgroupfamily
#
#   //Added parameter
#   parameter {
#     name  = "maxmemory-policy"
#     value = "allkeys-lru"
#   }
#
#   tags = {
#     Terraform = true
#     Name = "${local.common_name}-${local.artha_product}-${var.var_redis_paramgroupname}"
#     Product = local.artha_product
#     #    DateCreated = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
#     #    Owner  = var.global_aurora_primary_caller_id
#     ENV = local.env
#   }
# }
#
#
# resource "aws_elasticache_subnet_group" "redis_subnet_group" {
#   name       = "${local.common_name}-${local.artha_product}-${var.var_redis_subnetgroupname}"
#   subnet_ids = [aws_subnet.private_zone1.id,aws_subnet.private_zone2.id]
#
#   tags = {
#     Terraform = true
#     Name = "${local.common_name}-${local.artha_product}-${var.var_redis_subnetgroupname}"
#     Product = local.artha_product
#     #    DateCreated = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
#     #    Owner  = var.global_aurora_primary_caller_id
#     ENV = local.env
#   }
# }
#
#
# resource "aws_elasticache_replication_group" "redis_replication_group" {
#   replication_group_id          = "${local.common_name}-${local.artha_product}-${var.var_redis_replication_group_id}"
#   automatic_failover_enabled    = true //var.var_redis_automatic_failover
#   apply_immediately             = true
#   subnet_group_name             =  aws_elasticache_subnet_group.redis_subnet_group.name
#   description = "Replication group for"
#   node_type                     = var.var_redis_instance_class
#   engine_version                = var.var_redis_engine_version
#   #  num_cache_clusters         = var.var_redis_nodes_number
#   #  cluster_mode {
#   replicas_per_node_group = var.var_redis_replica_nodes_number
#   num_node_groups         = var.var_redis_nodes_number
#   #  }
#   parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.id
#   port                          = var.var_redis_port
#   security_group_ids            = [aws_security_group.core_redis_secgroup.id]
#   snapshot_retention_limit = 0
#
#   lifecycle {
#     ignore_changes = [num_node_groups]
#   }
#   tags = {
#     Terraform = true
#     Name = "${local.common_name}-${local.artha_product}-${var.var_redis_replication_group_id}"
#     Product = local.artha_product
#     #    DateCreated = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
#     #    Owner  = var.global_aurora_primary_caller_id
#     ENV = local.env
#   }
# }
#
#
#

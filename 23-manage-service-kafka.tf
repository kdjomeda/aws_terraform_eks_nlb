# resource "aws_security_group" "core_kafka_secgroup" {
#   name        = "${local.common_name}-${local.artha_product}-kafka-secgroup"
#   description = "Security Group for Managed Service for Kafka"
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
#
#   ingress {
#     from_port   = var.var_mskcluster_secgroup_from_port
#     to_port     = var.var_mskcluster_secgroup_to_port
#     protocol    = "tcp"
#     security_groups = [aws_security_group.bastion_host_secgroup.id]
#     description = "Allow from bastion host"
#   }
#
#   ingress {
#     from_port   = var.var_mskcluster_secgroup_from_port
#     to_port     = var.var_mskcluster_secgroup_to_port
#     protocol    = "tcp"
#     security_groups = [aws_security_group.eks_core_nodes_secgroup.id]
#     description = "Allow all from core eks node group"
#   }
#
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${local.common_name}-${local.artha_product}-kafka-secgroup"
#     Product = local.artha_product
#     ENV = local.env
#     Terraform = true
#   }
# }
#
#
# # Creating the configuration that should apply to the kafka cluster
# resource "aws_msk_configuration" "kafka_queue_configuration" {
#   name              = "${local.common_name}-${local.artha_product}-${var.var_mskcluster_cluster_configuration_name}"
#   server_properties = <<PROPERTIES
# auto.create.topics.enable=${var.var_mskcluster_properties_auto_create}
# default.replication.factor=${var.var_mskcluster_properties_replication_factor}
# min.insync.replicas=${var.var_mskcluster_properties_mni_insync_replicas}
# num.io.threads=${var.var_mskcluster_properties_io_thread}
# num.network.threads=${var.var_mskcluster_properties_network_thread}
# num.partitions=${var.var_mskcluster_properties_partitions}
# num.replica.fetchers=${var.var_mskcluster_properties_replica_fetchers}
# replica.lag.time.max.ms=${var.var_mskcluster_properties_replica_max_lagtime}
# socket.receive.buffer.bytes=${var.var_mskcluster_properties_receive_buffer_bytes}
# socket.request.max.bytes=${var.var_mskcluster_properties_request_max_bytes}
# socket.send.buffer.bytes=${var.var_mskcluster_properties_send_buffer_bytes}
# unclean.leader.election.enable=${var.var_mskcluster_properties_unclean_leader_election}
# zookeeper.session.timeout.ms=${var.var_mskcluster_properties_session_timeout}
# PROPERTIES
# }
#
# # creating MSK cluster
# resource "aws_msk_cluster" "kafka_queue_cluster" {
#   cluster_name           = "${local.common_name}-${local.artha_product}-${var.var_mskcluster_cluster_name}"
#   kafka_version          = var.var_mskcluster_kafka_version
#   number_of_broker_nodes = var.var_mskcluster_number_of_broker_nodes
#
#   configuration_info {
#     arn      = aws_msk_configuration.kafka_queue_configuration.arn
#     revision = aws_msk_configuration.kafka_queue_configuration.latest_revision
#   }
#   broker_node_group_info {
#     instance_type = var.var_mskcluster_msk_instance_type
#     client_subnets = [aws_subnet.private_zone1.id,aws_subnet.private_zone2.id]
#
#     storage_info {
#       ebs_storage_info {
#         volume_size = var.var_mskcluster_ebs_volume_size
#       }
#     }
#     security_groups = [aws_security_group.core_kafka_secgroup.id]
#   }
#   encryption_info {
#     encryption_in_transit {
#       client_broker = var.var_mskcluster_encryption_info_client_broker
#     }
#   }
#   tags = {
#     Terraform = true
#     Name = "${local.common_name}-${local.artha_product}-${var.var_mskcluster_cluster_name}"
#     Product = local.artha_product
#     ENV = local.env
#   }
# }
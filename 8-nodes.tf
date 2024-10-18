# resource "aws_iam_role" "nodes" {
#   name = "${local.common_name}-${local.region_name}-${local.env}_${local.eks_name}-node"
#   assume_role_policy =<<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#       {
#           "Effect": "Allow",
#           "Action": "sts:AssumeRole",
#           "Principal": {
#               "Service": "ec2.amazonaws.com"
#           }
#       }
#    ]
# }
# POLICY
# }
#
# resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.nodes.name
# }
#
# resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.nodes.name
# }
#
# resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_readonly_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.nodes.name
# }
#
# resource "aws_security_group" "eks_nodes_secgroup" {
#   name   = "${local.env}-node-secgroup"
#   vpc_id = aws_vpc.main.id
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#
# resource "aws_eks_node_group" "general" {
#   cluster_name  = aws_eks_cluster.eks.name
#   node_role_arn = aws_iam_role.nodes.arn
#   version = local.eks_version
#   node_group_name = "general"
#
#   subnet_ids = [
#     aws_subnet.private_zone1.id,
#     aws_subnet.private_zone2.id
#   ]
#
#
#   capacity_type = "ON_DEMAND"
#   instance_types = ["t3.large"]
#
#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }
#
#   update_config {
#     max_unavailable = 1
#   }
# labels = {
#   role = "general"
# }
#   depends_on = [
#   aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
#   aws_iam_role_policy_attachment.amazon_eks_cni_policy,
#   aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly_policy
#   ]
#
#
#   lifecycle {
#     ignore_changes = [scaling_config[0].desired_size]
#   }
# }
resource "aws_iam_role" "core_nodes" {
  name = "${local.common_name}-${local.artha_eks_name}-node"
  assume_role_policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
              "Service": "ec2.amazonaws.com"
          }
      }
   ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.core_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.core_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.core_nodes.name
}

resource "aws_security_group" "eks_core_nodes_secgroup" {
  name   = "${local.common_name}-${local.artha_eks_name}-node-secgroup"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eks_node_group" "core_node_group" {
  cluster_name  = aws_eks_cluster.core_eks.name
  node_role_arn = aws_iam_role.core_nodes.arn
  version = local.eks_version
  node_group_name = "${local.common_name}-${local.artha_eks_name}"

  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]


  capacity_type = "ON_DEMAND"
  instance_types = var.var_artha_node_group_instances_type

  scaling_config {
    desired_size = var.var_artha_node_group_instances_desired
    max_size     = var.var_artha_node_group_instances_max
    min_size     = var.var_artha_node_group_instances_min
  }

  update_config {
    max_unavailable = 1
  }
labels = {
  role = "general"
}
  depends_on = [
  aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
  aws_iam_role_policy_attachment.amazon_eks_cni_policy,
  aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly_policy
  ]


  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
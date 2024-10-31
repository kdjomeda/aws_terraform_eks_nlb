resource "aws_iam_role" "core_eks" {
  name = "${local.common_name}-${local.artha_eks_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "core_eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.core_eks.name
}

resource "aws_eks_cluster" "core_eks" {
  name = "${local.common_name}-${local.artha_eks_name}"
  version = local.eks_version
  role_arn = aws_iam_role.core_eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id
    ]

  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }


  depends_on = [aws_iam_role_policy_attachment.core_eks]
}


resource "aws_eks_addon" "core_pod_identity" {
  cluster_name = aws_eks_cluster.core_eks.name
  addon_name = "eks-pod-identity-agent"
  addon_version = "v1.3.2-eksbuild.2"
}

resource "aws_eks_addon" "core_vpc_cni" {
  cluster_name = aws_eks_cluster.core_eks.name
  addon_name = "vpc-cni"
#   addon_version = "v1.18.5"
}


# module "core_eks_blueprints_addons" {
#   source  = "aws-ia/eks-blueprints-addons/aws"
#   version = "~> 1.16"
#
#   cluster_name      = module.eks.cluster_name
#   cluster_endpoint  = module.eks.cluster_endpoint
#   cluster_version   = module.eks.cluster_version
#   oidc_provider_arn = module.eks.oidc_provider_arn
#
#   # Using GitOps Bridge
#   create_kubernetes_resources = false
#
#   # EKS Blueprints Addons
#   enable_cert_manager                 = true
#   enable_aws_efs_csi_driver           = false
#   enable_aws_fsx_csi_driver           = false
#   enable_aws_cloudwatch_metrics       = true
#   enable_aws_privateca_issuer         = true
#   enable_cluster_autoscaler           = false
#   enable_external_dns                 = true
#   enable_external_secrets             = false
#   enable_aws_load_balancer_controller = true
#   enable_fargate_fluentbit            = false
#   enable_aws_for_fluentbit            = false
#   enable_aws_node_termination_handler = false
#   enable_karpenter                    = true
#   enable_velero                       = false
#   enable_aws_gateway_api_controller   = false
#
#   tags = local.tags
# }
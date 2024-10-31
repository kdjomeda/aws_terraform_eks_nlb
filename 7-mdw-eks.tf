

//////////////////////////////////////// Question: Where is this admin role from. Usually it's needs to be created
# data "aws_iam_role" "eks_admin_role_name" {
#   name = var.eks_admin_role_name
# }


resource "aws_iam_role" "eks_admin_role_name" {
  name = "${local.common_name}-admin-role"

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

resource "aws_iam_policy" "eks_admin" {
  name = "${local.common_name}-AmazonEKSAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:UpdateAutoScalingGroup",
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateRoute",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteRoute"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin_role_name.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_role_policy_attachment" "eks_aws_managed_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_admin_role_name.name
}

################################################################################
# EKS Cluster
################################################################################
#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name                   = "${local.common_name}-${local.eks_name}"
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  authentication_mode = local.authentication_mode

  # Combine root account, current user/role and additional roles to be able to access the cluster KMS key - required for terraform updates
  kms_key_administrators = distinct(concat([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"],
    [data.aws_iam_session_context.current.issuer_arn]
  ))

  enable_cluster_creator_admin_permissions = true
  access_entries = {
    # One access entry with a policy associated
    eks_admin = {
      principal_arn     = aws_iam_role.eks_admin_role_name.arn
      policy_associations = {
        argocd = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  eks_managed_node_groups = {

    "${local.common_name}-mdw" = {
      instance_types = var.var_mdw_node_group_instances_type

      min_size     = var.var_mdw_node_group_instances_min
      max_size     = var.var_mdw_node_group_instances_max
      desired_size = var.var_mdw_node_group_instances_desired
    }

  }

  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni = {
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }
  tags = local.tags
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Using GitOps Bridge
  create_kubernetes_resources = false

  # EKS Blueprints Addons
  enable_cert_manager                 = true
  enable_aws_efs_csi_driver           = false
  enable_aws_fsx_csi_driver           = false
  enable_aws_cloudwatch_metrics       = true
  enable_aws_privateca_issuer         = true
  enable_cluster_autoscaler           = false
  enable_external_dns                 = true
  enable_external_secrets             = false
  enable_aws_load_balancer_controller = true
  enable_fargate_fluentbit            = false
  enable_aws_for_fluentbit            = false
  enable_aws_node_termination_handler = false
  enable_karpenter                    = true
  enable_velero                       = false
  enable_aws_gateway_api_controller   = false

  tags = local.tags
}

# data "aws_eks_cluster" "eks" {
#   name = aws_eks_cluster.eks.name
# }

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        # This requires the awscli to be installed locally where Terraform is executed
        args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
      }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
#   }
}
resource "aws_security_group" "core_aws_eks_alb_secgroup" {
  name        = "${local.common_name}-${local.artha_eks_name}-alb-secgroup"
  description = "Security Group for EKS Artha"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.var_cloudflare_whitelist_cidr
    description = "Allow Connectivity from Internet through CF"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.var_cloudflare_whitelist_cidr
    description = "Temp Allow Connectivity from Internet through CF"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Allow Connectivity from Internet from Office"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Temp Allow Connectivity from Internet from Office"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.bastion_host_secgroup.id]
    description = "Allow all from bastion host"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.forti_internal_secgroup.id]
    description = "Allow all from fortigate"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-${local.artha_eks_name}-alb-secgroup"
  }
}



data "aws_iam_policy_document" "core_aws_lbc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "core_aws_lbc" {
  name               = "${local.common_name}${local.artha_product}-eks-lb"
  assume_role_policy = data.aws_iam_policy_document.core_aws_lbc.json
}

resource "aws_iam_policy" "core_aws_lbc" {
  policy = file("${path.module}/config/iam/aws_load_balancer_controller.json")
  name   = "${local.env}-${local.artha_product}-core-eks-lbc"
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.core_aws_lbc.arn
  role       = aws_iam_role.core_aws_lbc.name
}

resource "aws_eks_pod_identity_association" "core_aws_lbc" {
  cluster_name    = aws_eks_cluster.core_eks.name
  namespace       = "kube-system"
  service_account = "${local.common_name}-${local.artha_product}-eks-lbc"
  role_arn        = aws_iam_role.core_aws_lbc.arn
}
#
# resource "terraform_data" "switch_to_core_eks" {
#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --region ${local.region} --profile ${var.profile} --name ${aws_eks_cluster.core_eks.name}"
#     interpreter = ["/bin/zsh", "-c"]
#   }
#   depends_on = [helm_release.alb-controller]
# }
#
#
#
#
# resource "helm_release" "aws_lbc" {
#   name = "core-aws-load-balancer-controller"
#
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.8.1"
#
#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.core_eks.name
#   }
#
#   set {
#     name  = "serviceAccount.name"
#     value = "${local.env}-${local.artha_product}-core-eks-lbc"
#   }
#
#   set {
#     name  = "vpcId"
#     value = aws_vpc.main.id
#   }
#
#   depends_on = [aws_eks_cluster.core_eks,terraform_data.switch_to_core_eks]
# }
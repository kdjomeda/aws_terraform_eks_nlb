resource "aws_iam_role" "mdw_cluster_autoscaler" {

  name = "${module.eks.cluster_name}-auto-scaler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_policy" "mdw_cluster_autoscaler" {
  name = "${module.eks.cluster_name}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "mdw_cluster_autoscaler" {
  policy_arn = aws_iam_policy.mdw_cluster_autoscaler.arn
  role       = aws_iam_role.mdw_cluster_autoscaler.name
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name = module.eks.cluster_name
  namespace = "kube-system"
  role_arn = aws_iam_role.mdw_cluster_autoscaler.arn
  service_account = "cluster-autoscaler"
}

resource "helm_release" "mdw_cluster_autoscaler" {
  chart = "cluster-autoscaler"
  name  = "autoscaler"
  namespace = "kube-system"
  version = "9.37.0"
  repository = "https://kubernetes.github.io/autoscaler"


  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks.cluster_name
  }

  # MUST be updated to match your region
  set {
    name  = "awsRegion"
    value = local.region
  }

  depends_on = [helm_release.metric_server]

}
# data "aws_caller_identity" "current" {}

resource "aws_iam_role" "core_eks_admin" {
  name = "${local.env}-${local.artha_product}-eks-admin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "core_eks_admin" {
  name = "${local.common_name}-${local.artha_product}-AmazonEKSAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "core_eks_admin" {
  role       = aws_iam_role.core_eks_admin.name
  policy_arn = aws_iam_policy.core_eks_admin.arn
}

resource "aws_eks_access_entry" "core_eks_admin" {
  cluster_name      = aws_eks_cluster.core_eks.name
  principal_arn     = aws_iam_role.core_eks_admin.arn
  kubernetes_groups = ["core-admin"]
}
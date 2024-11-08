# # data "aws_caller_identity" "current" {}
#
resource "aws_iam_role" "core_eks_manager" {
  name = "${local.env}-${local.artha_product}-eks-manager"

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

resource "aws_iam_policy" "core_eks_manager" {
  name = "${local.common_name}-${local.artha_product}-AmazonEKSManagerPolicy"

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

resource "aws_iam_role_policy_attachment" "core_eks_manager" {
  role       = aws_iam_role.core_eks_manager.name
  policy_arn = aws_iam_policy.core_eks_manager.arn
}

resource "aws_eks_access_entry" "core_eks_manager" {
  cluster_name      = module.core_eks.cluster_name
  principal_arn     = aws_iam_role.core_eks_manager.arn
  kubernetes_groups = ["art-manager"]
}
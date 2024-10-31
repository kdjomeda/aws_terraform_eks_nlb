# data "aws_caller_identity" "current" {}

resource "aws_iam_role" "mdw_eks_admin" {
  name = "${local.env}-${local.mdw_product}-eks-admin"

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

resource "aws_iam_policy" "mdw_eks_admin" {
  name = "${local.common_name}-${local.mdw_product}-AmazonEKSAdminPolicy"

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

resource "aws_iam_role_policy_attachment" "mdw_eks_admin" {
  role       = aws_iam_role.mdw_eks_admin.name
  policy_arn = aws_iam_policy.mdw_eks_admin.arn
}
#
# resource "aws_iam_user" "manager" {
#   name = "manager"
# }
#
# resource "aws_iam_policy" "eks_assume_admin" {
#   name = "AmazonEKSAssumeAdminPolicy"
#
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "sts:AssumeRole"
#             ],
#             "Resource": "${aws_iam_role.eks_admin.arn}"
#         }
#     ]
# }
# POLICY
# }
#
# resource "aws_iam_user_policy_attachment" "manager" {
#   user       = aws_iam_user.manager.name
#   policy_arn = aws_iam_policy.eks_assume_admin.arn
# }
#
# Best practice: use IAM roles due to temporary credentials
resource "aws_eks_access_entry" "mdw_eks_admin" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.mdw_eks_admin.arn
  kubernetes_groups = ["mdw-admin"]
}
resource "aws_iam_role" "mdw_eks_developer" {
  name = "${local.common_name}-${local.mdw_product}-eks-developer"

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



resource "aws_iam_policy" "mdw_eks_developer" {
  name = "${local.common_name}-${local.mdw_product}-AmazonEKSDeveloperPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "mdw_eks_developer" {
  role = aws_iam_role.mdw_eks_developer.name
  policy_arn = aws_iam_policy.mdw_eks_developer.arn
}

resource "aws_eks_access_entry" "mdw_eks_developer" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.mdw_eks_developer.arn
  kubernetes_groups = ["mdw-developer"]
}
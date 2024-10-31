resource "aws_iam_role" "core_eks_developer" {
  name = "${local.common_name}-${local.artha_product}-eks-developer"

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



resource "aws_iam_policy" "core_eks_developer" {
  name = "${local.common_name}-${local.artha_product}-AmazonEKSDeveloperPolicy"

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

resource "aws_iam_role_policy_attachment" "core_eks_developer" {
  role = aws_iam_role.core_eks_developer.name
  policy_arn = aws_iam_policy.core_eks_developer.arn
}

resource "aws_eks_access_entry" "core_eks_developer" {
  cluster_name      = aws_eks_cluster.core_eks.name
  principal_arn     = aws_iam_role.core_eks_developer.arn
  kubernetes_groups = ["core-developer"]
}
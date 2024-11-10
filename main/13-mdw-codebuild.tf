# # data "aws_caller_identity" "current" {}
# arn for ecr namespace
# ${data.aws_caller_identity.current.account_id}.dkr.${local.region}.amazonaws.com/${local.common_name}-${local.mdw_product}
# resource "aws_secretsmanager_secret" "mdw_codebuild" {
#   name = "${local.env}-${local.mdw_product}-github-token"
#   tags = {
#     Name = "${local.env}-${local.mdw_product}-github-token"
#     ENV = local.env
#     Product = local.mdw_product
#     "codebuild:source" = ""
#     "codebuild:source:provider"= "github"
#     "codebuild:source:type" = "personal_access_token"
#   }
# }
#
#
# resource "aws_secretsmanager_secret_version" "mdw_codebuild" {
#   secret_id = aws_secretsmanager_secret.mdw_codebuild.id
#   secret_string = <<EOF
#    {
#     "ServerType": "GITHUB",
#     "AuthType": "PERSONAL_ACCESS_TOKEN",
#     "Token": "${var.var_mdw_github_token}"
#    }
# EOF
# }
# ,
# {
# "Sid": "SidGetSecretValue",
# "Effect": "Allow",
# "Action": [
# "secretsmanager:GetSecretValue"
# ],
# "Resource": [
# "${aws_secretsmanager_secret.mdw_codebuild.arn}"
# ]
# }

resource "aws_cloudwatch_log_group" "mdw_codebuild" {
  name = "${local.env}-${local.mdw_product}-codebuild-log"
  log_group_class = "STANDARD"
  retention_in_days = 7
  tags = {
    Name = "${local.env}-${local.mdw_product}-codebuild-log"
    ENV = local.env
    Product = local.mdw_product
  }
}


resource "aws_iam_role" "mdw_codebuild" {
  name = "${local.env}-${local.mdw_product}-codebuild-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "mdw_codebuild" {
  name = "${local.common_name}-${local.mdw_product}-CodeBuildPolicy"
#arn:aws:logs:eu-west-1:058264357478:log-group:/aws/codebuild
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },    {
      "Effect": "Allow",
      "Action": [
        "rds:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
                   "${aws_cloudwatch_log_group.mdw_codebuild.arn}",
                   "${aws_cloudwatch_log_group.mdw_codebuild.arn}:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
       "ecr:GetAuthorizationToken",
        "ecr:DescribeRepositories",
        "ecr:CreateRepository",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecs:UpdateService"
      ],
      "Resource": "*"
    },
	{
      "Effect": "Allow",
      "Action": "codestar-connections:UseConnection",
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Resource": [
            "arn:aws:s3:::codepipeline-eu-west-1-*"
        ],
        "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "eks:DescribeNodegroup",
            "eks:DescribeUpdate",
            "eks:DescribeCluster"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
        ],
        "Resource": [
            "arn:aws:codebuild:${local.region}:${data.aws_caller_identity.current.account_id}:report-group/*"
        ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "mdw_codebuild" {
  role       = aws_iam_role.mdw_codebuild.name
  policy_arn = aws_iam_policy.mdw_codebuild.arn
}

resource "aws_eks_access_entry" "mdw_codebuild" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.mdw_codebuild.arn
  kubernetes_groups = ["mdw-cicd"]
}
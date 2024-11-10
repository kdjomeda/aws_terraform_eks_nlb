# # # data "aws_caller_identity" "current" {}
# #
# resource "aws_iam_role" "mdw_codepipeline" {
#   name = "${local.env}-${local.mdw_product}-codepipeline-role"
#
#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "AWS": "codepipeline.amazonaws.com"
#       }
#     }
#   ]
# }
# POLICY
# }
#
# resource "aws_iam_policy" "mdw_codepipeline" {
#   name = "${local.common_name}-${local.mdw_product}-AmazonEKSCodePipelinePolicy"
#
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codecommit:CancelUploadArchive",
#         "codecommit:GetBranch",
#         "codecommit:GetCommit",
#         "codecommit:GetUploadArchiveStatus",
#         "codecommit:UploadArchive"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codedeploy:CreateDeployment",
#         "codedeploy:GetApplicationRevision",
#         "codedeploy:GetDeployment",
#         "codedeploy:GetDeploymentConfig",
#         "codedeploy:RegisterApplicationRevision"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:BatchGetBuilds",
#         "codebuild:StartBuild"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "devicefarm:ListProjects",
#         "devicefarm:ListDevicePools",
#         "devicefarm:GetRun",
#         "devicefarm:GetUpload",
#         "devicefarm:CreateUpload",
#         "devicefarm:ScheduleRun"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "lambda:InvokeFunction",
#         "lambda:ListFunctions"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "iam:PassRole"
#       ],
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "elasticbeanstalk:*",
#         "ec2:*",
#         "elasticloadbalancing:*",
#         "autoscaling:*",
#         "cloudwatch:*",
#         "s3:*",
#         "sns:*",
#         "cloudformation:*",
#         "rds:*",
#         "sqs:*",
#         "ecs:*"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# POLICY
# }
#
# resource "aws_iam_role_policy_attachment" "mdw_codepipeline" {
#   role       = aws_iam_role.mdw_codepipeline.name
#   policy_arn = aws_iam_policy.mdw_codepipeline.arn
# }
#
# # # # Best practice: use IAM roles due to temporary credentials
# # # resource "aws_eks_access_entry" "mdw_codepipeline" {
# # #   cluster_name      = module.eks.cluster_name
# # #   principal_arn     = aws_iam_role.mdw_codepipeline.arn
# # #   kubernetes_groups = ["mdw-admin"]
# # # }
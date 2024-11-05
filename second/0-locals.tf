data "terraform_remote_state" "shared_resources" {
  backend = "local"
  config = {
    path = "${path.module}/../main/terraform.tfstate"
  }
}

locals {
  env = "prod"
  region_name = "ire"
  region = "eu-west-1"
  zone1 = "eu-west-1a"
  zone2 = "eu-west-1b"
  eks_name = "mdw-eks-act01"
  artha_eks_name = "art-eks-act01"
  eks_version = "1.30"
  common_name = "gmfs-ire-prod"
  mdw_product = "mdw"
  artha_product = "art"


  cluster_version = var.kubernetes_version

  vpc_id = data.terraform_remote_state.shared_resources.outputs.output_vpc_id
  private_subnets = data.terraform_remote_state.shared_resources.outputs.output_vpc_private_subnets_ids

  authentication_mode = var.authentication_mode

  tags = {
    Blueprint  = local.artha_eks_name
    Name       = "${local.common_name}-${local.artha_product}-worker-node"
    GithubRepo = "github.com/aws-samples/eks-blueprints-for-terraform-workshop"
  }

}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_session_context" "current" {
  # This data source provides information on the IAM source role of an STS assumed role
  # For non-role ARNs, this data source simply passes the ARN through issuer ARN
  # Ref https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
  # Ref https://github.com/hashicorp/terraform-provider-aws/issues/28381
  arn = data.aws_caller_identity.current.arn
}


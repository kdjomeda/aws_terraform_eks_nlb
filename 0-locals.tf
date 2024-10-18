locals {
  env = "prod"
  region_name = "ire"
  region = "eu-west-1"
  zone1 = "eu-west-1a"
  zone2 = "eu-west-1b"
  eks_name = "mdw-eks-act01"
  eks_version = "1.30"
  common_name = "gmfs-ire-prod"

  ## From Eke
  name            = "hub-gmfs-prod-cluster"
#   region          = data.aws_region.current.id
  cluster_version = var.kubernetes_version

  vpc_id = aws_vpc.main.id
  private_subnets = [aws_subnet.private_zone1.id,aws_subnet.private_zone2.id]

  authentication_mode = var.authentication_mode

  tags = {
    Blueprint  = local.eks_name
    Name       = "${local.common_name}-mdw-worker-node"
    GithubRepo = "github.com/aws-samples/eks-blueprints-for-terraform-workshop"
  }

}
# resource "aws_security_group" "aws_eks_nlb_secgroup" {
#   name        = "${local.common_name}-eks-nlb-secgroup"
#   description = "Security Group for EKS NLB"
#   vpc_id      = aws_vpc.main.id
#
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     #     cidr_blocks = ["41.155.68.45/32"]
#     security_groups = [aws_security_group.forti_internal_secgroup.id]
#     description = "Allow Access to Fortigate"
#   }
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Temp Allow Connectivity from Internet for esting"
#   }
#
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Temp Allow Connectivity from Internet for esting"
#   }
#
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "${local.common_name}-eks-nlb-secgroup"
#   }
# }
#
#
#
# resource "helm_release" "ingress-nginx" {
#   name             = "ingress-nginx"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   namespace        = "ingress-nginx"
#   create_namespace = true
#   version          = "4.10.0"
#   values           = [file("${path.module}/config/nginx/nginx.yaml")]
#   wait =  false
# }
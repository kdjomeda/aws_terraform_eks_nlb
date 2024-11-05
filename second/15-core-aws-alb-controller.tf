
resource "aws_security_group" "core_aws_eks_alb_secgroup" {
  name        = "${local.common_name}-${local.artha_eks_name}-alb-secgroup"
  description = "Security Group for EKS Artha"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.var_cloudflare_whitelist_cidr
    description = "Allow Connectivity from Internet through CF"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.var_cloudflare_whitelist_cidr
    description = "Temp Allow Connectivity from Internet through CF"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Allow Connectivity from Internet from Office"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.var_office_ips
    description = "Temp Allow Connectivity from Internet from Office"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [data.terraform_remote_state.shared_resources.outputs.output_secgroup_bastion_host_id]
    description = "Allow all from bastion host"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [data.terraform_remote_state.shared_resources.outputs.output_secgroup_forti_internal_id]
    description = "Allow all from fortigate"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-${local.artha_eks_name}-alb-secgroup"
  }
}


module "core_lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${local.common_name}_${local.artha_product}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.core_eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}


resource "kubernetes_service_account" "core_service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.core_lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}



resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.core_service-account
  ]


  set {
    name  = "region"
    value = local.region
  }

  set {
    name  = "vpcId"
    value = local.vpc_id
  }

  set {
    name  = "image.repository"
    #     value = "602401143452.dkr.ecr.${var.main-region}.amazonaws.com/amazon/aws-load-balancer-controller"
    value = "public.ecr.aws/eks/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.core_eks.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.core_lb_role.iam_role_arn
  }
}

## Disable the creation of the Deployment, Service and the Ingress by terraform
#
# resource "kubernetes_deployment" "echoserver-deployment" {
#
#
#   metadata  {
#     name      = "echoserver"
#     namespace = "default"
#   }
#
#   spec  {
#     selector  {
#       match_labels = {
#         app=  "arthatest"
#       }
#     }
#     replicas = 1
#     template  {
#       metadata  {
#         labels = {
#           app=  "arthatest"
#         }
#       }
#       spec {
#         container {
#           name = "echoserver"
#           image = "k8s.gcr.io/e2e-test-images/echoserver:2.5"
#           #           image = "traefik:v3.1"
#           port {
#             container_port = 8080
#           }
# #           args = ["--api.insecure"]
#         }
#       }
#
#     }
#   }
# }
#
#
#
# resource "kubernetes_service" "arthatest-service" {
#   metadata {
#     name = "arthatest"
#     namespace = "default"
#   }
#   spec {
#     type = "ClusterIP"
#     port {
#       port = 8080
#       target_port = "http"
#     }
#     selector = {
#       "app" = "arthatest"
#     }
#   }
# }
#
# resource "kubernetes_ingress_v1" "gmfs-load-balancer" {
#   metadata {
#     name = "arthatest"
#     namespace = "default"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type" = "ip"
#       "alb.ingress.kubernetes.io/healthcheck-path" = "/health"
#       "alb.ingress.kubernetes.io/security-groups" = "${aws_security_group.core_aws_eks_alb_secgroup.id}"
#       "alb.ingress.kubernetes.io/manage-backend-security-group-rules" = "true"
#       "alb.ingress.kubernetes.io/load-balancer-name" = "${local.common_name}-alb-${local.artha_product}"
#     }
#   }
#   spec {
#     ingress_class_name = "alb"
#     rule {
#       host = "test.gmfs.com"
#       http {
#         path {
#           path = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "arthatest"
#               port {
#                 number = "8080"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
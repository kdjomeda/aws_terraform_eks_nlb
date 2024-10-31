resource "aws_security_group" "aws_eks_nlb_secgroup" {
  name        = "${local.common_name}-eks-nlb-secgroup"
  description = "Security Group for EKS NLB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    #     cidr_blocks = ["41.155.68.45/32"]
    security_groups = [aws_security_group.forti_internal_secgroup.id]
    description = "Allow ICMP Access to Fortigate"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Temp Allow Connectivity from Internet for esting"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Temp Allow Connectivity from Internet for esting"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.bastion_host_secgroup.id]
    description = "Allow all from bastion host"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.forti_internal_secgroup.id]
    description = "Allow all from fortigate"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.common_name}-eks-nlb-secgroup"
  }
}


module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${local.common_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}


resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
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
    kubernetes_service_account.service-account
  ]


  set {
    name  = "region"
    value = local.region
  }

  set {
    name  = "vpcId"
    value = aws_vpc.main.id
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
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.lb_role.iam_role_arn
  }
}

resource "kubernetes_deployment" "echoserver-deployment" {


  metadata  {
    name      = "echoserver"
    namespace = "default"
  }

  spec  {
    selector  {
      match_labels = {
        app=  "gmfs-ire-prod-nlb-mdw"
      }
    }
    replicas = 1
    template  {
      metadata  {
        labels = {
          app=  "gmfs-ire-prod-nlb-mdw"
        }
      }
      spec {
        container {
          name = "echoserver"
          image = "k8s.gcr.io/e2e-test-images/echoserver:2.5"
#           image = "traefik:v3.1"
          port {
            container_port = 8080
          }
          args = ["--api.insecure"]
        }
      }

    }
  }
}


resource "kubernetes_service" "gmfs-load-balancer" {
  metadata {
    name      = "${local.common_name}-nlb-mdw"
    namespace = "default"
    annotations = {
      # AWS Load Balancer Annotations
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"                     = "tcp"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled"    = "true"
      "service.beta.kubernetes.io/aws-load-balancer-type"                                 = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout"              = "60"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type"                      = "ip"
      "service.beta.kubernetes.io/aws-load-balancer-type"                                 = "external"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"                               = "internal"
      "service.beta.kubernetes.io/aws-load-balancer-subnets"                              = "${aws_subnet.private_zone1.id},${aws_subnet.private_zone2.id}"
      "service.beta.kubernetes.io/aws-load-balancer-private-ipv4-addresses"               = "10.0.0.20, 10.0.32.20"
      "service.beta.kubernetes.io/aws-load-balancer-manage-backend-security-group-rules"  = "true"
      "service.beta.kubernetes.io/aws-load-balancer-security-groups"                      = aws_security_group.aws_eks_nlb_secgroup.id
      "service.beta.kubernetes.io/aws-load-balancer-name"                                 = "${local.common_name}-nlb-mdw"
#       "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"                       = "*"
#       "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"                            = "443"
#       "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy"               = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    }
  }

  spec {
    selector = {
      "app" = "${local.common_name}-nlb-mdw"
    }

    port {
      name = "http-port"
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }

#     port {
#       name = "https-port"
#       port        = 443
#       target_port = 8080
#       protocol    = "TCP"
#     }

    type = "LoadBalancer"
  }
}

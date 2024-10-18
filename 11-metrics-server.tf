  resource "helm_release" "metric_server" {
    name  = "metrics-server"

    repository = "https://kubernetes-sigs.github.io/metrics-server/"
    chart = "metrics-server"
    namespace = "kube-system"
    version = "3.12.1"

    values = [file("${path.module}/config/metricsserver/metrics-server.yaml")]

  }
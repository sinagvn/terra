resource "helm_release" "grafana" {
  name = "grafana"
  namespace = "grafana"

  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"

  values = [
    "${file("${path.module}/k6-grafana-values.yaml")}"
  ]

  depends_on = [
    kubernetes_secret.grafana_creds
  ]
}

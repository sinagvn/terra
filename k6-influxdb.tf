resource "helm_release" "influxdb" {
  name = "influx-db"
  namespace = "influxdb"
  repository = "https://helm.influxdata.com/"
  chart = "influxdb"

  values = [
    "${file("${path.module}/k6-influx-values.yaml")}"
  ]

  depends_on = [
    kubernetes_secret.influxdb_creds,
  ]
}

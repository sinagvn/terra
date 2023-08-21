data "aws_secretsmanager_secret_version" "grafana_creds" {
  secret_id = "GrafanaCredentials"
}

resource "kubernetes_secret" "grafana_creds" {
  metadata {
    name = "grafana-creds"
    namespace = "grafana"
  }

  data = {
    "admin-user" = "grafanaadmin" 
    "admin-password" = jsondecode(data.aws_secretsmanager_secret_version.grafana_creds.secret_string)["admin_password"]
  }

}

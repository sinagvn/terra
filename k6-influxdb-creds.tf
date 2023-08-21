data "aws_secretsmanager_secret_version" "influxdb_creds" {
  secret_id = "InfluxDBCredentials"
}

resource "kubernetes_secret" "influxdb_creds" {
  metadata {
    name = "influxdb-creds"
    namespace = "influxdb"
  }

  data = {
    "INFLUXDB_USER_PASSWORD" = jsondecode(data.aws_secretsmanager_secret_version.influxdb_creds.secret_string)["user_password"]
    "INFLUXDB_WRITE_USER_PASSWORD" = jsondecode(data.aws_secretsmanager_secret_version.influxdb_creds.secret_string)["write_user_password"]
    "INFLUXDB_READ_USER_PASSWORD" = jsondecode(data.aws_secretsmanager_secret_version.influxdb_creds.secret_string)["read_user_password"]
    "INFLUXDB_ADMIN_PASSWORD" = jsondecode(data.aws_secretsmanager_secret_version.influxdb_creds.secret_string)["admin_password"]
  }

}

resource "aws_efs_file_system" "influxdb_efs" {
}

resource "aws_efs_mount_target" "influxdb_efs_mount_target" {
  file_system_id = aws_efs_file_system.influxdb_efs.id
  for_each = toset(var.vpc_private_subnets)//make sure to pass your vpc's private subnets.
  subnet_id = each.value
  security_groups = [ module.efs_security_group.security_group_id ]
}

resource "kubernetes_storage_class" "influxdb_storage_class" {
  metadata {
    name = "gp2"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
}

resource "kubernetes_storage_class" "qa_infra_storage_class" {
  metadata {
    name = "gp2"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
}

resource "kubernetes_persistent_volume" "influxdb_pv" {
  metadata {
    name = "influxdb-pv"
  }

  spec {
    capacity = {
      "storage" = "50Gi"
    }
    volume_mode = "Filesystem"
    access_modes = [ "ReadWriteOnce" ]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = kubernetes_storage_class.influxdb_storage_class.metadata[0].name
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.influxdb_efs.id
      }
    }
  }
}

resource "kubernetes_persistent_volume" "grafana_pv" {
  metadata {
    name = "grafana-pv"
  }
  spec {
    capacity = {
      "storage" = "5Gi"
    }
    volume_mode = "Filesystem"
    access_modes = [ "ReadWriteOnce" ]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = kubernetes_storage_class.qa_infra_storage_class.metadata[0].name
    persistent_volume_source {
      csi {
        driver = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.influxdb_efs.id
      }
    }
  }
}

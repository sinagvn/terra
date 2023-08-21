resource "null_resource" "k6_operator" {
  provisioner "local-exec" {
    command = "./${path.module}/install_k6_operator.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./${path.module}/uninstall_k6_operator.sh"
  }
}

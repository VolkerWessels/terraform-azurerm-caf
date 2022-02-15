resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo $VARIABLE1 >> debug.json; echo $VARIABLE2 >> debug.json; echo $VARIABLE3 >> debug.json; cat debug.json"
    environment = {
      VARIABLE1 = jsonencode(local.managed_local_identity)
      VARIABLE2 = jsonencode(local.managed_remote_identity)
      VARIABLE3 = jsonencode(var.managed_identities)
    }
  }
}

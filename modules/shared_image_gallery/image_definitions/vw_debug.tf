resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
  command = "echo $VARIABLE1 >> debug_caf_root.json; echo $VARIABLE2 >> debug_caf_root.json; cat debug_caf_root.json"
    environment = {
      VARIABLE1 = jsonencode(azurerm_shared_image.image.name)
      VARIABLE2 = jsonencode(azurerm_shared_image.image.id)
    }
  }
}

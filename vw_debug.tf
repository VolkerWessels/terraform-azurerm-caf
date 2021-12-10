resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
  command = "echo $VARIABLE1 >> debug_caf_root.json; echo $VARIABLE2 >> debug_caf_root.json; echo $VARIABLE3 >> debug_caf_root.json; echo $VARIABLE4 >> debug_caf_root.json; echo $VARIABLE5 >> debug_caf_root.json; echo $VARIABLE6 >> debug_caf_root.json; cat debug_caf_root.json"
    environment = {
      VARIABLE1 = jsonencode(local.combined_objects_image_definitions)
      VARIABLE2 = jsonencode(var.remote_objects.image_definitions)
      VARIABLE3 = jsonencode(local.shared_services)
      VARIABLE4 = jsonencode(var.shared_services)
      VARIABLE5 = jsonencode(var.remote_objects)
    }
  }
}

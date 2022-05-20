resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo $VARIABLE1 >> debug.json; echo $VARIABLE2 >> debug.json; cat debug.json"
    environment = {
      VARIABLE1 = jsonencode(try(local.azuread.azuread_groups, ""))
      VARIABLE2 = jsonencode(try(local.combined_objects_azuread_groups, ""))
      VARIABLE3 = jsonencode(try(module.azuread_groups, ""))
    }
  }
}

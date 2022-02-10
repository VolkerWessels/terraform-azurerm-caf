terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }

}

resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
  command = "echo $VARIABLE1 >> debug.json; echo $VARIABLE2 >> debug.json; cat debug.json"
    environment = {
      VARIABLE1 = jsonencode(var.global_settings)
      VARIABLE2 = jsonencode(var.diagnostics)
      #VARIABLE3 = jsonencode(var.networking)
    } 
  }
}

locals {
  os_type = lower(var.settings.os_type)
  # Generate SSH Keys only if a public one is not provided
  create_sshkeys = (local.os_type == "linux" || local.os_type == "legacy") && try(var.settings.public_key_pem_file == "", true)
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.base_tags, local.module_tag, try(var.settings.tags, null))
}
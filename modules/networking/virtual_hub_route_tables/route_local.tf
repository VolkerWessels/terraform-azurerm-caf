locals {
  routes = flatten(
    [
      for route, value in try(var.settings.routes, []) : {
        name            = value.name
        destinationType = try(upper(value.destinations_type), "CIDR")
        destinations    = value.destinations
        nextHopType     = "ResourceId"
        nextHop         = can(value.next_hop_id) || can(value.next_hop) == false ? try(value.next_hop_id, "") : var.remote_objects[value.next_hop.resource_type][try(value.next_hop.lz_key, var.client_config.landingzone_key)][value.next_hop.key].id
      }
    ]
  )
}

resource "null_resource" "debug" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo $VARIABLE1 >> debug.json; cat debug.json"
    environment = {
      VARIABLE1 = jsonencode(var.remote_objects)
      #VARIABLE2 = jsonencode(azurerm_shared_image.image.name)
    }
  }
}
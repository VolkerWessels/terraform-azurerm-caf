#
# Process membership for var.azuread_groups in members attribute
#

data "azuread_user" "upn" {
  for_each = toset(try(var.settings.members.user_principal_names, []))

  user_principal_name = each.value
}

module "user_principal_names" {
  source   = "./member"
  for_each = toset(try(var.settings.members.user_principal_names, []))

  group_object_id  = var.group_id
  member_object_id = data.azuread_user.upn[each.key].id
}

module "service_principals" {
  source   = "./member"
  for_each = toset(try(var.settings.members.service_principal_keys, []))

  group_object_id  = var.group_id
  member_object_id = var.azuread_apps[each.key].azuread_service_principal.object_id
}

module "azuread_service_principals" {
  source   = "./member"
  for_each = toset(try(var.settings.members.azuread_service_principal_keys, []))

  group_object_id  = var.group_id
  member_object_id = var.azuread_service_principals[var.client_config.landingzone_key][each.key].object_id
}

# resource "null_resource" "debug" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = "echo $VARIABLE1 >> debug.json; echo $VARIABLE2 >> debug.json; echo $VARIABLE3 >> debug.json; echo $VARIABLE4 >> debug.json; cat debug.json"
#     environment = {
#       VARIABLE1 = jsonencode(try(var.azuread_service_principals, ""))
#       VARIABLE2 = jsonencode(try(var.group_id, ""))
#       VARIABLE3 = jsonencode(try(var.settings, ""))
#       VARIABLE4 = jsonencode(try(var.azuread_groups, ""))
#     }
#   }
# }

module "object_id" {
  source   = "./member"
  for_each = toset(try(var.settings.members.object_ids, []))

  group_object_id  = var.group_id
  member_object_id = each.value
}

data "azuread_group" "name" {
  for_each = toset(try(var.settings.members.group_names, []))

  display_name = each.value
}

module "group_name" {
  source   = "./member"
  for_each = toset(try(var.settings.members.group_names, []))

  group_object_id  = var.group_id
  member_object_id = data.azuread_group.name[each.key].id
}

module "group_keys" {
  source   = "./member"
  for_each = toset(try(var.settings.members.group_keys, []))

  group_object_id  = var.group_id
  member_object_id = var.azuread_groups[each.key].id
}

module "security_center" {
  source   = "./modules/security/security_center/"
  for_each = try(local.security.security_center, {})
  settings = each.value
}

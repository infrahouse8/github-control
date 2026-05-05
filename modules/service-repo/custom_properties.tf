resource "github_repository_custom_property" "this" {
  for_each       = var.custom_properties
  repository     = github_repository.this.name
  property_name  = each.key
  property_type  = each.value.type
  property_value = each.value.value
}

locals {
  acronym = "yury-lab-05"
}

module "resource_group" {
  for_each = var.rg_locations

  source = "./modules/resource_group"

  location = each.value.location
  name     = "rg-${local.acronym}-${each.key}"
}

module "app_service_plan" {
  for_each = var.app_service_locations

  source = "./modules/app_service_plan"

  name                = "plan-${local.acronym}-${each.key}"
  resource_group_name = module.resource_group[each.key].name
  location            = module.resource_group[each.key].location
  sku_name            = each.value.sku_name
  os_type             = each.value.os_type
}


module "web_app" {
  for_each = var.app_service_locations

  source = "./modules/app_service"

  name                = "app-${local.acronym}-${each.key}"
  resource_group_name = module.resource_group[each.key].name
  location            = module.resource_group[each.key].location
  service_plan_id     = module.app_service_plan[each.key].id

  site_config = {
    worker_count = lookup(each.value, "worker_count", 1)
  }
}

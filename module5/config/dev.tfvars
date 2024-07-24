environment = "dev"


rg_locations = {
  neu = {
    location = "North Europe"
  }
  weu = {
    location = "West Europe"
  }
  uks = {
    location = "UK South"
  }
}

app_service_locations = {
  neu = {
    sku_name = "S1"
    os_type  = "Windows"
  }
  weu = {
    sku_name     = "S1"
    os_type      = "Windows"
    worker_count = 2
  }
}

output "name" {
  value = azurerm_resource_group.example.name
}


output "location" {
  description = "Resource Group Location"
  value       = azurerm_resource_group.example.location
}

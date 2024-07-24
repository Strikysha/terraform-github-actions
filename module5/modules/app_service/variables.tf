variable "name" {
  description = "The name of the web app"
}
variable "resource_group_name" {
  description = "The name of the resource group"
}
variable "location" {
  description = "The location of the web app"
}
variable "service_plan_id" {
  description = "The ID of the App Service Plan"
}

variable "worker_count" {
  description = "The number of workers"
  default     = 1

}

variable "site_config" {
  description = "The site configuration"
  type = object({
    worker_count = optional(number, 1)
  })
  default = {}
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "tf-rg"
}

variable "app_insights_name" {
  description = "Name of Application Insights"
  type        = string
  default     = "tf-appinsights"
}

variable "app_service_plan_name" {
  description = "Name of App Service Plan"
  type        = string
  default     = "tf-app-plan"
}

variable "app_service_name" {
  description = "Name of App Service"
  type        = string
  default     = "tf-app-service"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "example-app"
  }
}

# Terraform Azure App Service with Application Insights

This project provisions a basic Azure App Service using Terraform and connects it with Azure Application Insights.

## What it Deploys

- Azure Resource Group
- Azure Application Insights (type: web)
- Azure App Service Plan (B1)
- Azure App Service with telemetry integration

## Files

- `main.tf`: Main infrastructure definition

## Requirements

- Terraform >= 1.3
- Azure CLI logged in
- `azurerm` provider configured

## Usage

```bash
terraform init
terraform plan
terraform apply

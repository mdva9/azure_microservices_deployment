# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Managed Identity pour les services
resource "azurerm_user_assigned_identity" "identity" {
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}

# App Service Plan (partagé entre les deux microservices)
resource "azurerm_service_plan" "app_service_plan" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"  # Basic tier
}

# App Service pour Spring Boot
resource "azurerm_linux_web_app" "service-java-58493-he2b" {
  name                = var.service-java
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.identity.client_id

    application_stack {
      docker_image_name   = var.service-java_image
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  app_settings = {
    WEBSITES_PORT = var.service_java_port
    FLASK_URL = "https://${azurerm_linux_web_app.service-python.default_hostname}"
  }
}


# App Service pour Python
resource "azurerm_linux_web_app" "service-python" {
  name                = var.service-python
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.identity.client_id

    application_stack {
      docker_image_name   = var.service-python_image
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  app_settings = {
    WEBSITES_PORT = var.service_python_port
  }
}

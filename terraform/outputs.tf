output "container_registry_login_server" {
  description = "Adresse du registre ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "service_java_url" {
  description = "URL du endpoint proxy de l'application Spring Boot"
  value       = "https://${azurerm_linux_web_app.service-java-58493-he2b.default_hostname}/proxy"
}

output "service-python_url" {
  description = "URL du service flask"
  value       = "https://${azurerm_linux_web_app.service-python.default_hostname}/api/message"
}

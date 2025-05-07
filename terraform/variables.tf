variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-microservices"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "myacrregistry58493"
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
  default     = "microservices-identity"
}

variable "service_plan_name" {
  description = "Name of the App Service plan"
  type        = string
  default     = "microservices-plan"
}

variable "service-java" {
  description = "Spring Boot App"
  type        = string
  default     = "service-java-58493-he2b"
}

variable "service-python" {
  description = "flask"
  type        = string
  default     = "python-service"
}

variable "service-java_image" {
  description = "Docker image name and tag of Spring Boot App"
  type        = string
   default     = "service-java:latest"
}

variable "service-python_image" {
  description = "Docker image name and tag of Service Flask"
  type        = string
  default     = "service-python:latest"
}

variable "service_java_port" {
  description = "Port on which the Spring Boot app listens"
  type        = string
  default     = "8080"
}

variable "service_python_port" {
  description = "Port on which the Python app listens"
  type        = string
  default     = "5000"
}

variable "aws_region" {
  description = "Region de AWS"
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Nombre del repositorio ECR"
  type        = string
  default     = "techmarket-app"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "prod"
}

output "repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.techmarket.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.techmarket.name
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.techmarket.name
}

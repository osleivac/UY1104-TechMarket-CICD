output "repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.techmarket.repository_url
}

output "repository_arn" {
  description = "ARN del repositorio ECR"
  value       = aws_ecr_repository.techmarket.arn
}

output "registry_id" {
  description = "ID del registro ECR"
  value       = aws_ecr_repository.techmarket.registry_id
}

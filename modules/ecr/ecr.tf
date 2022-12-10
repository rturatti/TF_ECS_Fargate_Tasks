resource "aws_ecr_repository" "repositorio" {
  name = "${var.name_repository}-ecr"
}

output "ARN" {
  value       = aws_ecr_repository.repositorio.arn
  sensitive   = false
  description = "ARN do repositório ECR"
  depends_on  = []
}
output "ECR_Name" {
  value       = aws_ecr_repository.repositorio.name
  sensitive   = false
  description = "Nome do repositório ECR"
}
output "ECR_Repository_URL" {
  value       = aws_ecr_repository.repositorio.repository_url
  sensitive   = false
  description = "URL do repositório ECR"
}
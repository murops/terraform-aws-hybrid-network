output "endpoint" {
  description = "Endereço de conexão do banco (host:porta)."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Hostname do banco."
  value       = aws_db_instance.this.address
}

output "master_user_secret_arn" {
  description = "ARN do segredo no Secrets Manager com o usuário e a senha do administrador."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}

output "security_group_id" {
  description = "Security group do banco."
  value       = aws_security_group.this.id
}

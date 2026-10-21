output "instance_id" {
  description = "ID da instância. Acesso: aws ssm start-session --target <instance_id>"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "IP privado da instância, alcançável a partir do escritório pela VPN."
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Security group da aplicação (liberado no banco de dados)."
  value       = aws_security_group.this.id
}

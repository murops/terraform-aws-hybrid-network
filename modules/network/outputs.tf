output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "Bloco CIDR da VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas de aplicação."
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs das subnets isoladas de banco de dados."
  value       = aws_subnet.database[*].id
}

output "private_route_table_ids" {
  description = "IDs das tabelas de rota privadas (usadas para propagar as rotas da VPN)."
  value       = aws_route_table.private[*].id
}

output "database_route_table_ids" {
  description = "IDs das tabelas de rota de banco de dados (usadas para propagar as rotas da VPN)."
  value       = [aws_route_table.database.id]
}

output "nat_public_ips" {
  description = "IPs públicos de saída dos NAT Gateways (úteis para liberar em firewalls externos)."
  value       = aws_eip.nat[*].public_ip
}

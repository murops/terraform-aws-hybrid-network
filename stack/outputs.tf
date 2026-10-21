output "vpc_id" {
  description = "ID da VPC."
  value       = module.network.vpc_id
}

output "nat_public_ips" {
  description = "IPs de saída para a internet."
  value       = module.network.nat_public_ips
}

output "vpn_tunnel_addresses" {
  description = "IPs dos túneis AWS para configurar no firewall do escritório."
  value       = try(module.vpn[0].tunnel_addresses, null)
}

output "vpn_connection_id" {
  description = "ID da conexão VPN (baixe a configuração do firewall no console)."
  value       = try(module.vpn[0].vpn_connection_id, null)
}

output "app_instance_id" {
  description = "Instância da aplicação. Acesso: aws ssm start-session --target <id>"
  value       = module.app.instance_id
}

output "app_private_ip" {
  description = "IP privado da aplicação, acessível do escritório pela VPN."
  value       = module.app.private_ip
}

output "db_endpoint" {
  description = "Endpoint do PostgreSQL, acessível da aplicação e do escritório pela VPN."
  value       = module.database.endpoint
}

output "db_master_user_secret_arn" {
  description = "Segredo com a senha do administrador do banco."
  value       = module.database.master_user_secret_arn
}

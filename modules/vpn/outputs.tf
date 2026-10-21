output "vpn_gateway_id" {
  description = "ID do Virtual Private Gateway."
  value       = aws_vpn_gateway.this.id
}

output "vpn_connection_id" {
  description = "ID da conexão VPN. No console é possível baixar a configuração pronta para o modelo do firewall."
  value       = aws_vpn_connection.office.id
}

output "tunnel_addresses" {
  description = "IPs públicos dos dois túneis do lado AWS, para configurar no firewall do escritório."
  value = {
    tunnel1 = aws_vpn_connection.office.tunnel1_address
    tunnel2 = aws_vpn_connection.office.tunnel2_address
  }
}

output "tunnel_preshared_keys" {
  description = "Chaves pré-compartilhadas dos túneis. Leia com: terraform output -json tunnel_preshared_keys"
  sensitive   = true
  value = {
    tunnel1 = aws_vpn_connection.office.tunnel1_preshared_key
    tunnel2 = aws_vpn_connection.office.tunnel2_preshared_key
  }
}

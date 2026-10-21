variable "name" {
  description = "Prefixo usado no nome de todos os recursos."
  type        = string
}

variable "vpc_id" {
  description = "VPC onde o Virtual Private Gateway será anexado."
  type        = string
}

variable "route_table_ids" {
  description = "Tabelas de rota que recebem as rotas da rede on-premises via propagação."
  type        = list(string)
}

variable "customer_gateway_ip" {
  description = "IP público fixo do firewall/roteador do escritório."
  type        = string

  validation {
    condition     = can(cidrhost("${var.customer_gateway_ip}/32", 0))
    error_message = "customer_gateway_ip precisa ser um IPv4 válido."
  }
}

variable "customer_gateway_bgp_asn" {
  description = "ASN do lado on-premises. Obrigatório pela AWS mesmo com rotas estáticas."
  type        = number
  default     = 65000
}

variable "amazon_side_asn" {
  description = "ASN do lado AWS (Virtual Private Gateway)."
  type        = number
  default     = 64512
}

variable "static_routes_only" {
  description = "true = rotas estáticas (firewalls sem BGP). false = rotas dinâmicas via BGP."
  type        = bool
  default     = true
}

variable "onprem_cidrs" {
  description = "Redes do escritório que serão alcançáveis pela VPN (usadas nas rotas estáticas)."
  type        = list(string)
}

variable "tunnel_security" {
  description = "Algoritmos aceitos nas fases 1 e 2 do IPsec. O padrão restringe a opções fortes."
  type = object({
    ike_versions            = list(string)
    phase1_encryption       = list(string)
    phase1_integrity        = list(string)
    phase1_dh_group_numbers = list(number)
    phase2_encryption       = list(string)
    phase2_integrity        = list(string)
    phase2_dh_group_numbers = list(number)
  })
  default = {
    ike_versions            = ["ikev2"]
    phase1_encryption       = ["AES256", "AES256-GCM-16"]
    phase1_integrity        = ["SHA2-256", "SHA2-512"]
    phase1_dh_group_numbers = [14, 19, 20]
    phase2_encryption       = ["AES256", "AES256-GCM-16"]
    phase2_integrity        = ["SHA2-256", "SHA2-512"]
    phase2_dh_group_numbers = [14, 19, 20]
  }
}

variable "tags" {
  description = "Tags adicionais aplicadas a todos os recursos do módulo."
  type        = map(string)
  default     = {}
}

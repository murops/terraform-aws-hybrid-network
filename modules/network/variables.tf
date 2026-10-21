variable "name" {
  description = "Prefixo usado no nome de todos os recursos."
  type        = string
}

variable "cidr_block" {
  description = "Bloco CIDR da VPC. Não pode se sobrepor às redes on-premises."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block precisa ser um CIDR IPv4 válido, por exemplo 10.20.0.0/16."
  }
}

variable "azs" {
  description = "Zonas de disponibilidade usadas pelas subnets, na mesma ordem das listas de CIDR."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas (NAT Gateway e, se houver, load balancers). Uma por AZ."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_subnet_cidrs) <= length(var.azs)
    error_message = "Defina no máximo uma subnet pública por AZ."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas de aplicação. Uma por AZ."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) <= length(var.azs)
    error_message = "Defina no máximo uma subnet privada por AZ."
  }
}

variable "database_subnet_cidrs" {
  description = "CIDRs das subnets isoladas de banco de dados (sem rota para a internet). Mínimo de duas AZs para o RDS."
  type        = list(string)

  validation {
    condition     = length(var.database_subnet_cidrs) >= 2 && length(var.database_subnet_cidrs) <= length(var.azs)
    error_message = "O RDS exige subnets de banco em pelo menos duas AZs, no máximo uma por AZ."
  }
}

variable "enable_nat_gateway" {
  description = "Cria NAT Gateway para as subnets privadas acessarem a internet (atualizações, APIs externas)."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Usa um único NAT Gateway para todas as AZs. Mais barato, porém sem alta disponibilidade."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Envia os VPC Flow Logs para o CloudWatch Logs."
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Dias de retenção dos Flow Logs no CloudWatch."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags adicionais aplicadas a todos os recursos do módulo."
  type        = map(string)
  default     = {}
}

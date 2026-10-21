variable "project" {
  description = "Nome do projeto. Compõe o nome dos recursos e a tag Project."
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, hml, prod...). Compõe o nome dos recursos e a tag Environment."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Use apenas letras minúsculas, números e hífen."
  }
}

variable "region" {
  description = "Região da AWS."
  type        = string
  default     = "sa-east-1"
}

variable "vpc_cidr" {
  description = "CIDR da VPC. Não pode se sobrepor às redes do escritório."
  type        = string
}

variable "azs" {
  description = "Zonas de disponibilidade."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Subnets públicas (NAT Gateway)."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Subnets privadas de aplicação."
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "Subnets isoladas de banco de dados."
  type        = list(string)

  validation {
    condition     = length(var.database_subnet_cidrs) >= 2
    error_message = "O RDS exige subnets de banco em pelo menos duas AZs."
  }
}

variable "single_nat_gateway" {
  description = "Um NAT para todas as AZs (mais barato) ou um por AZ (alta disponibilidade)."
  type        = bool
  default     = true
}

variable "enable_vpn" {
  description = "Cria a VPN site-to-site com o escritório."
  type        = bool
  default     = true
}

variable "office_public_ip" {
  description = "IP público fixo do firewall do escritório."
  type        = string
  default     = null

  validation {
    condition     = !var.enable_vpn || var.office_public_ip != null
    error_message = "Com enable_vpn = true, informe office_public_ip."
  }
}

variable "office_cidrs" {
  description = "Redes internas do escritório que acessam a AWS pela VPN."
  type        = list(string)
}

variable "app_instance_type" {
  description = "Tipo da instância EC2 da aplicação."
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_multi_az" {
  description = "RDS com réplica em outra AZ."
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Protege o banco contra exclusão."
  type        = bool
  default     = true
}

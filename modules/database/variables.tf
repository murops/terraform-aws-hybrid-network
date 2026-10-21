variable "name" {
  description = "Prefixo usado no nome de todos os recursos."
  type        = string
}

variable "vpc_id" {
  description = "VPC do security group do banco."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets isoladas de banco de dados (mínimo duas AZs)."
  type        = list(string)
}

variable "engine_version" {
  description = "Versão do PostgreSQL. Informando só a major (ex.: 17), a AWS escolhe a minor mais recente."
  type        = string
  default     = "17"
}

variable "instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Armazenamento inicial em GiB."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Limite do autoscaling de armazenamento em GiB."
  type        = number
  default     = 100
}

variable "database_name" {
  description = "Nome do banco criado na instância."
  type        = string
  default     = "app"
}

variable "master_username" {
  description = "Usuário administrador. A senha é gerada e guardada pela AWS no Secrets Manager."
  type        = string
  default     = "app_admin"
}

variable "multi_az" {
  description = "Réplica síncrona em outra AZ, para alta disponibilidade."
  type        = bool
  default     = false
}

variable "backup_retention_days" {
  description = "Dias de retenção dos backups automáticos."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Impede que o banco seja apagado por engano (inclusive por terraform destroy)."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Não cria snapshot final ao apagar o banco. Use true apenas em ambientes descartáveis."
  type        = bool
  default     = false
}

variable "allowed_security_group_ids" {
  description = "Security groups autorizados a conectar na porta do PostgreSQL (ex.: o da aplicação)."
  type        = list(string)
  default     = []
}

variable "allowed_cidrs" {
  description = "Redes autorizadas a conectar no banco (ex.: rede do escritório via VPN)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags adicionais aplicadas a todos os recursos do módulo."
  type        = map(string)
  default     = {}
}

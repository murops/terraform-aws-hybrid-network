variable "name" {
  description = "Prefixo usado no nome de todos os recursos."
  type        = string
}

variable "vpc_id" {
  description = "VPC do security group da instância."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR da VPC, liberado na saída para a aplicação alcançar o banco e serviços internos."
  type        = string
}

variable "subnet_id" {
  description = "Subnet privada onde a instância será criada."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI da instância. Se vazio, usa o Amazon Linux 2023 mais recente."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Tamanho do disco raiz em GiB."
  type        = number
  default     = 20
}

variable "ingress_ports" {
  description = "Portas TCP liberadas para as redes em allowed_cidrs."
  type        = list(number)
  default     = [80, 443]
}

variable "allowed_cidrs" {
  description = "Redes autorizadas a acessar a instância (normalmente as redes do escritório via VPN)."
  type        = list(string)
}

variable "tags" {
  description = "Tags adicionais aplicadas a todos os recursos do módulo."
  type        = map(string)
  default     = {}
}

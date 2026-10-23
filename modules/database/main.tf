locals {
  port = 5432
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-db" })
}

resource "aws_security_group" "this" {
  name        = "${var.name}-db"
  description = "PostgreSQL: acesso somente da aplicacao e das redes autorizadas"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name}-db" })
}

resource "aws_vpc_security_group_ingress_rule" "from_security_groups" {
  count = length(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.this.id
  description                  = "PostgreSQL a partir da aplicacao"
  ip_protocol                  = "tcp"
  from_port                    = local.port
  to_port                      = local.port
  referenced_security_group_id = var.allowed_security_group_ids[count.index]
}

resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  for_each = toset(var.allowed_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "PostgreSQL a partir de ${each.value}"
  ip_protocol       = "tcp"
  from_port         = local.port
  to_port           = local.port
  cidr_ipv4         = each.value
}

resource "aws_db_instance" "this" {
  identifier     = "${var.name}-postgres"
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  port           = local.port

  db_name                     = var.database_name
  username                    = var.master_username
  manage_master_user_password = true

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  iam_database_authentication_enabled = true
  auto_minor_version_upgrade          = true
  backup_retention_period             = var.backup_retention_days
  copy_tags_to_snapshot               = true
  deletion_protection                 = var.deletion_protection
  skip_final_snapshot                 = var.skip_final_snapshot
  # Sufixo com a data de criação: um segundo ciclo criar/destruir não colide com o snapshot anterior.
  # Definido sempre (mesmo com skip_final_snapshot = true) para poder desligar o skip depois.
  final_snapshot_identifier       = "${var.name}-postgres-final-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(var.tags, { Name = "${var.name}-postgres" })

  lifecycle {
    # o timestamp() acima só vale na criação; sem isso, todo plan mostraria diferença
    ignore_changes = [final_snapshot_identifier]
  }
}

locals {
  name = "${var.project}-${var.environment}"
}

module "network" {
  source = "../modules/network"

  name                  = local.name
  cidr_block            = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  single_nat_gateway    = var.single_nat_gateway
}

module "vpn" {
  source = "../modules/vpn"
  count  = var.enable_vpn ? 1 : 0

  name                = local.name
  vpc_id              = module.network.vpc_id
  customer_gateway_ip = var.office_public_ip
  onprem_cidrs        = var.office_cidrs
  route_table_ids = concat(
    module.network.private_route_table_ids,
    module.network.database_route_table_ids,
  )
}

module "app" {
  source = "../modules/compute"

  name           = local.name
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  subnet_id      = module.network.private_subnet_ids[0]
  instance_type  = var.app_instance_type
  allowed_cidrs  = var.office_cidrs
}

module "database" {
  source = "../modules/database"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.database_subnet_ids
  instance_class             = var.db_instance_class
  multi_az                   = var.db_multi_az
  deletion_protection        = var.db_deletion_protection
  skip_final_snapshot        = !var.db_deletion_protection
  allowed_security_group_ids = [module.app.security_group_id]
  allowed_cidrs              = var.office_cidrs
}

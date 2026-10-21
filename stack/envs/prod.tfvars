project     = "hybrid"
environment = "prod"
region      = "sa-east-1"

vpc_cidr              = "10.30.0.0/16"
azs                   = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
public_subnet_cidrs   = ["10.30.0.0/24", "10.30.1.0/24", "10.30.2.0/24"]
private_subnet_cidrs  = ["10.30.10.0/24", "10.30.11.0/24", "10.30.12.0/24"]
database_subnet_cidrs = ["10.30.20.0/24", "10.30.21.0/24", "10.30.22.0/24"]
single_nat_gateway    = false

# exemplo: trocar pelos dados do escritório
enable_vpn       = true
office_public_ip = "203.0.113.10"
office_cidrs     = ["192.168.0.0/24", "192.168.10.0/24"]

app_instance_type      = "t3.small"
db_instance_class      = "db.t4g.small"
db_multi_az            = true
db_deletion_protection = true

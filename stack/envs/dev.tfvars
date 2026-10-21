project     = "hybrid"
environment = "dev"
region      = "sa-east-1"

vpc_cidr              = "10.20.0.0/16"
azs                   = ["sa-east-1a", "sa-east-1b"]
public_subnet_cidrs   = ["10.20.0.0/24", "10.20.1.0/24"]
private_subnet_cidrs  = ["10.20.10.0/24", "10.20.11.0/24"]
database_subnet_cidrs = ["10.20.20.0/24", "10.20.21.0/24"]
single_nat_gateway    = true

# exemplo: trocar pelos dados do escritório
enable_vpn       = true
office_public_ip = "203.0.113.10"
office_cidrs     = ["192.168.0.0/24"]

app_instance_type      = "t3.micro"
db_instance_class      = "db.t4g.micro"
db_multi_az            = false
db_deletion_protection = false

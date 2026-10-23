mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  mock_data "aws_ssm_parameter" {
    defaults = {
      value = "ami-0123456789abcdef0"
    }
  }

  mock_resource "aws_cloudwatch_log_group" {
    defaults = {
      arn = "arn:aws:logs:sa-east-1:123456789012:log-group:/vpc/flow-logs"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock"
    }
  }
}

variables {
  project               = "hybrid"
  environment           = "dev"
  vpc_cidr              = "10.20.0.0/16"
  azs                   = ["sa-east-1a", "sa-east-1b"]
  public_subnet_cidrs   = ["10.20.0.0/24", "10.20.1.0/24"]
  private_subnet_cidrs  = ["10.20.10.0/24", "10.20.11.0/24"]
  database_subnet_cidrs = ["10.20.20.0/24", "10.20.21.0/24"]
  single_nat_gateway    = true
  enable_vpn            = true
  office_public_ip      = "203.0.113.10"
  office_cidrs          = ["192.168.0.0/24"]
}

run "dev_usa_um_nat_compartilhado" {
  command = apply

  assert {
    condition     = length(output.nat_public_ips) == 1
    error_message = "Dev deve ter um único NAT Gateway."
  }

  assert {
    condition     = length(module.network.private_subnet_ids) == 2 && length(module.network.database_subnet_ids) == 2
    error_message = "Dev deve ter subnets privadas e de banco em 2 AZs."
  }
}

run "vpn_propaga_rotas_para_aplicacao_e_banco" {
  command = apply

  assert {
    condition     = length(module.vpn[0].tunnel_addresses) == 2
    error_message = "A VPN deve expor os dois túneis."
  }

  assert {
    condition     = length(module.network.private_route_table_ids) + length(module.network.database_route_table_ids) == 3
    error_message = "As rotas do escritório devem chegar nas tabelas privadas e de banco."
  }
}

run "prod_usa_um_nat_por_az" {
  command = apply

  variables {
    environment           = "prod"
    vpc_cidr              = "10.30.0.0/16"
    azs                   = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
    public_subnet_cidrs   = ["10.30.0.0/24", "10.30.1.0/24", "10.30.2.0/24"]
    private_subnet_cidrs  = ["10.30.10.0/24", "10.30.11.0/24", "10.30.12.0/24"]
    database_subnet_cidrs = ["10.30.20.0/24", "10.30.21.0/24", "10.30.22.0/24"]
    single_nat_gateway    = false
    db_multi_az           = true
  }

  assert {
    condition     = length(output.nat_public_ips) == 3
    error_message = "Prod deve ter um NAT Gateway por AZ."
  }
}

run "sem_vpn_nao_cria_recursos_de_vpn" {
  command = plan

  variables {
    enable_vpn       = false
    office_public_ip = null
  }

  assert {
    condition     = length(module.vpn) == 0
    error_message = "Com enable_vpn = false nenhum recurso de VPN deve ser criado."
  }
}

run "vpn_exige_ip_do_escritorio" {
  command = plan

  variables {
    office_public_ip = null
  }

  expect_failures = [var.office_public_ip]
}

run "banco_exige_duas_azs" {
  command = plan

  variables {
    database_subnet_cidrs = ["10.20.20.0/24"]
  }

  expect_failures = [var.database_subnet_cidrs]
}

run "prod_exige_protecao_contra_exclusao_do_banco" {
  command = plan

  variables {
    environment            = "prod"
    db_deletion_protection = false
  }

  expect_failures = [var.db_deletion_protection]
}

run "prod_exige_snapshot_final_do_banco" {
  command = plan

  variables {
    environment            = "prod"
    db_skip_final_snapshot = true
  }

  expect_failures = [var.db_skip_final_snapshot]
}

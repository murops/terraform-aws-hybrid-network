resource "aws_vpn_gateway" "this" {
  vpc_id          = var.vpc_id
  amazon_side_asn = var.amazon_side_asn

  tags = merge(var.tags, { Name = "${var.name}-vgw" })
}

resource "aws_customer_gateway" "office" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"

  tags = merge(var.tags, { Name = "${var.name}-office-cgw" })
}

resource "aws_vpn_connection" "office" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.office.id
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only

  tunnel1_ike_versions                 = var.tunnel_security.ike_versions
  tunnel1_phase1_encryption_algorithms = var.tunnel_security.phase1_encryption
  tunnel1_phase1_integrity_algorithms  = var.tunnel_security.phase1_integrity
  tunnel1_phase1_dh_group_numbers      = var.tunnel_security.phase1_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.tunnel_security.phase2_encryption
  tunnel1_phase2_integrity_algorithms  = var.tunnel_security.phase2_integrity
  tunnel1_phase2_dh_group_numbers      = var.tunnel_security.phase2_dh_group_numbers

  tunnel2_ike_versions                 = var.tunnel_security.ike_versions
  tunnel2_phase1_encryption_algorithms = var.tunnel_security.phase1_encryption
  tunnel2_phase1_integrity_algorithms  = var.tunnel_security.phase1_integrity
  tunnel2_phase1_dh_group_numbers      = var.tunnel_security.phase1_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = var.tunnel_security.phase2_encryption
  tunnel2_phase2_integrity_algorithms  = var.tunnel_security.phase2_integrity
  tunnel2_phase2_dh_group_numbers      = var.tunnel_security.phase2_dh_group_numbers

  tags = merge(var.tags, { Name = "${var.name}-office-vpn" })
}

resource "aws_vpn_connection_route" "onprem" {
  for_each = var.static_routes_only ? toset(var.onprem_cidrs) : toset([])

  vpn_connection_id      = aws_vpn_connection.office.id
  destination_cidr_block = each.value
}

resource "aws_vpn_gateway_route_propagation" "this" {
  count = length(var.route_table_ids)

  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = var.route_table_ids[count.index]
}

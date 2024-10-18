resource "aws_subnet" "forti_ha_sync_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.var_forti_ha_sync_zone1
  availability_zone = local.zone1

  tags = {
    "Name" = "${local.common_name}-hasync-${local.zone1}"
  }
}

resource "aws_subnet" "forti_ha_sync_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.var_forti_ha_sync_zone2
  availability_zone = local.zone2

  tags = {
    "Name" = "${local.common_name}-hasync-${local.zone2}"
  }
}

resource "aws_subnet" "forti_ha_mgmt_zone1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.var_forti_ha_mgmt_zone1
  availability_zone = local.zone1

  tags = {
    "Name" = "${local.common_name}-hamgmt-${local.zone1}"
  }
}

resource "aws_subnet" "forti_ha_mgmt_zone2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.var_forti_ha_mgmt_zone2
  availability_zone = local.zone2

  tags = {
    "Name" = "${local.common_name}-hamgmt-${local.zone2}"
  }
}

resource "aws_route_table_association" "forti-hasync-attachment_zone1" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.forti_ha_sync_zone1.id
}

resource "aws_route_table_association" "forti-hasync-attachment_zone2" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.forti_ha_sync_zone2.id
}

resource "aws_route_table_association" "forti-hamgmt-attachment_zone1" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.forti_ha_mgmt_zone1.id
}

resource "aws_route_table_association" "forti-hamgmt-attachment_zone2" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.forti_ha_mgmt_zone2.id
}

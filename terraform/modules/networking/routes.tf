resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.llm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.llm_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-public-rt-${var.environment}"
  })
}

resource "aws_route_table_association" "public_route_associations" {
  count = var.az_count

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_tables" {
  count = var.az_count

  vpc_id = aws_vpc.llm_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[var.nat_gateway_mode == "ha" ? count.index : 0].id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-private-rt-${count.index + 1}-${var.environment}"
  })
}

resource "aws_route_table_association" "private_route_associations" {
  count = var.az_count

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

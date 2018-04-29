resource "aws_subnet" "private" {
  count = "${length(var.availability_zones)}"

  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, 8, count.index + length(var.availability_zones) + 1)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"

  vpc = true

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = "${length(var.availability_zones)}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table" "private" {
  count = "${length(var.availability_zones)}"

  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.public.id}"
  }

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_network_acl" "private" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_network_acl_rule" "private_inbound" {
  network_acl_id = "${aws_network_acl.private.id}"
  rule_number    = 200
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_inbound_ipv6" {
  network_acl_id  = "${aws_network_acl.private.id}"
  rule_number     = 300
  egress          = false
  protocol        = "all"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "private_outbound" {
  network_acl_id = "${aws_network_acl.private.id}"
  rule_number    = 200
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_outbound_ipv6" {
  network_acl_id  = "${aws_network_acl.private.id}"
  rule_number     = 300
  egress          = true
  protocol        = "all"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

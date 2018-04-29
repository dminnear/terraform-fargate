resource "aws_subnet" "public" {
  count = "${length(var.availability_zones)}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
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

resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_network_acl" "public" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_network_acl_rule" "public_inbound" {
  network_acl_id = "${aws_network_acl.public.id}"
  rule_number    = 200
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_inbound_ipv6" {
  network_acl_id  = "${aws_network_acl.public.id}"
  rule_number     = 300
  egress          = false
  protocol        = "all"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = "${aws_network_acl.public.id}"
  rule_number    = 200
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_outbound_ipv6" {
  network_acl_id  = "${aws_network_acl.public.id}"
  rule_number     = 300
  egress          = true
  protocol        = "all"
  rule_action     = "allow"
  ipv6_cidr_block = "::/0"
}

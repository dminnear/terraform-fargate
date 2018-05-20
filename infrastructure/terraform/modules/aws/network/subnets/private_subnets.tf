resource "aws_subnet" "private" {
  count = "${length(var.availability_zones)}"

  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, 8, count.index + length(var.availability_zones) + 1)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name    = "${local.name}-private-${element(var.availability_zones, count.index)}"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  depends_on = ["aws_internet_gateway.public"]

  tags {
    Name    = "${local.name}-nat"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.0.id}"

  depends_on = ["aws_internet_gateway.public"]

  tags {
    Name    = "${local.name}"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name    = "${local.name}-private"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

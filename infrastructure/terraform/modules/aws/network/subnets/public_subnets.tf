resource "aws_subnet" "public" {
  count = "${length(var.availability_zones)}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name    = "${local.name}-public-${element(var.availability_zones, count.index)}"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name    = "${local.name}"
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

  tags {
    Name    = "${local.name}-public"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

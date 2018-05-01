resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

module "subnets" {
  source = "./subnets"

  project            = "${var.project}"
  env                = "${var.env}"
  vpc_id             = "${aws_vpc.vpc.id}"
  vpc_cidr_block     = "${var.vpc_cidr_block}"
  availability_zones = "${var.subnets_availability_zones}"
}

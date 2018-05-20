resource "aws_network_acl" "acl" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${concat(aws_subnet.public.*.id, aws_subnet.private.*.id)}"]

  tags {
    Name    = "${local.name}"
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_network_acl_rule" "inbound" {
  network_acl_id = "${aws_network_acl.acl.id}"
  rule_number    = 420
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "outbound" {
  network_acl_id = "${aws_network_acl.acl.id}"
  rule_number    = 420
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

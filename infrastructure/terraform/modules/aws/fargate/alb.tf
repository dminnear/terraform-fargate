resource "aws_security_group" "alb" {
  name   = "${local.name}-alb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "${local.name}-alb"
    Project = "${var.project}"
    Env     = "${var.env}"
    Service = "${var.name}"
  }
}

resource "aws_alb" "service" {
  name            = "${local.name}"
  internal        = "${var.alb_internal}"
  subnets         = ["${var.alb_subnets}"]
  security_groups = ["${aws_security_group.alb.id}"]

  tags {
    Name    = "${local.name}"
    Project = "${var.project}"
    Env     = "${var.env}"
    Service = "${var.name}"
  }
}

resource "aws_alb_target_group" "service" {
  name        = "${local.name}"
  port        = "${var.port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  depends_on = ["aws_alb.service"]

  health_check {
    matcher = "200-399"
  }

  tags {
    Name    = "${local.name}"
    Project = "${var.project}"
    Env     = "${var.env}"
    Service = "${var.name}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.service.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.service.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.id}"
    type             = "forward"
  }
}

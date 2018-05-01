resource "aws_security_group" "backend-alb" {
  name   = "${local.name}-alb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_alb" "backend" {
  name            = "${local.name}"
  subnets         = ["${var.private_subnets}"]
  security_groups = ["${aws_security_group.backend-alb.id}"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_alb_target_group" "backend" {
  name        = "${local.name}"
  port        = "${var.port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/health"
  }

  depends_on = ["aws_alb.backend"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_alb_listener" "backend" {
  load_balancer_arn = "${aws_alb.backend.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.backend.id}"
    type             = "forward"
  }
}

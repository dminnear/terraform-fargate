resource "aws_security_group" "frontend-alb" {
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

resource "aws_alb" "frontend" {
  name            = "${local.name}"
  subnets         = ["${var.public_subnets}"]
  security_groups = ["${aws_security_group.frontend-alb.id}"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_alb_target_group" "frontend" {
  name        = "${local.name}"
  port        = "${var.port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/health"
  }

  depends_on = ["aws_alb.frontend"]

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn = "${aws_alb.frontend.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend.id}"
    type             = "forward"
  }
}

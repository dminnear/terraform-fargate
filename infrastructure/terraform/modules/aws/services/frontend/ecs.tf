resource "aws_security_group" "frontend-ecs" {
  name   = "${local.name}-ecs-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    security_groups = ["${aws_security_group.frontend-alb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Project = "${var.project}"
    Env     = "${var.env}"
  }
}

resource "aws_ecs_cluster" "frontend" {
  name = "${local.name}"
}

resource "aws_ecs_service" "frontend" {
  name            = "${local.name}"
  cluster         = "${aws_ecs_cluster.frontend.id}"
  task_definition = "${aws_ecs_task_definition.frontend.arn}"
  desired_count   = "${var.desired_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.frontend-ecs.id}"]
    subnets         = ["${var.private_subnets}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.frontend.id}"
    container_name   = "${local.name}"
    container_port   = "${var.port}"
  }
}

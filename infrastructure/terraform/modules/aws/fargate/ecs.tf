resource "aws_security_group" "ecs" {
  name   = "${local.name}-ecs-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    security_groups = ["${aws_security_group.alb.id}"]
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
    Service = "${var.name}"
  }
}

resource "aws_ecs_cluster" "service" {
  name = "${local.name}"
}

resource "aws_ecs_service" "service" {
  name            = "${local.name}"
  cluster         = "${aws_ecs_cluster.service.id}"
  task_definition = "${aws_ecs_task_definition.service.arn}"
  desired_count   = "${var.desired_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs.id}"]
    subnets         = ["${var.ecs_subnets}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service.id}"
    container_name   = "${local.name}"
    container_port   = "${var.port}"
  }
}

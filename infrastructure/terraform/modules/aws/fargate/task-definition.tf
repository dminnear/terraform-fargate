resource "aws_ecs_task_definition" "service" {
  family                   = "${local.name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.cpu},
    "environment": [],
    "essential": true,
    "image": "${var.image}",
    "memory": ${var.memory},
    "mountPoints":[],
    "name": "${local.name}",
    "portMappings": [
      {
        "containerPort": ${var.port},
        "hostPort":${var.port},
        "protocol":"tcp"
      }
    ],
    "volumesFrom": []
  }
]
DEFINITION
}

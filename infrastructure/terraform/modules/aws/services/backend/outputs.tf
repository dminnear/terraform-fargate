output "url" {
  value = "${aws_alb.backend.dns_name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.backend.id}"
}

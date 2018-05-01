output "url" {
  value = "${aws_alb.service.dns_name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.service.id}"
}

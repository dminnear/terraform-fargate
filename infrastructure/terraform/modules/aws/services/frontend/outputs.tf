output "url" {
  value = "${aws_alb.frontend.dns_name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.frontend.id}"
}

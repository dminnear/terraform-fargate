output "alb_dns_name" {
  value = "${aws_alb.service.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.service.zone_id}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.service.id}"
}

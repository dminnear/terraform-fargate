output "frontend_url" {
  value = "${module.frontend.url}"
}

output "backend_url" {
  value = "${module.backend.url}"
}

output "frontend_ecs_cluster_id" {
  value = "${module.frontend.ecs_cluster_id}"
}

output "backend_ecs_cluster_id" {
  value = "${module.backend.ecs_cluster_id}"
}

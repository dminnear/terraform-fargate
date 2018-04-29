output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_subnet_ids" {
  value = "${module.subnets.private_subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.subnets.public_subnet_ids}"
}

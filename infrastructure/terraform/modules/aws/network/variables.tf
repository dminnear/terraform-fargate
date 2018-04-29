variable "project" {
  description = "The name of the project"
}

variable "env" {
  description = "The name of the env"
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
}

variable "subnets_availability_zones" {
  type        = "list"
  description = "Availability zones to place the subnets"
}

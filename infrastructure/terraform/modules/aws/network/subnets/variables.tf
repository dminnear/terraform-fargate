variable "project" {
  description = "The name of the project"
}

variable "env" {
  description = "The name of the env"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zones to place the subnets"
}

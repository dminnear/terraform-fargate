variable "project" {
  description = "The name of the project"
}

variable "env" {
  description = "The name of the env"
}

variable "cpu" {
  description = "The number of cpu units to reserve for this service"
  default     = 256
}

variable "memory" {
  description = "The number of memory units to reserve for this service"
  default     = 512
}

variable "image" {
  description = "The docker image to use for this service"
}

variable "port" {
  description = "The port this service runs on in the docker image"
}

variable "desired_count" {
  description = "The number of instances of this service to run"
  default     = 1
}

variable "private_subnets" {
  type        = "list"
  description = "The private subnets to associate with this service"
}

variable "public_subnets" {
  type        = "list"
  description = "The public subnets to associate with the ALB"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
}

locals {
  name = "${var.project}-${var.env}-backend"
}

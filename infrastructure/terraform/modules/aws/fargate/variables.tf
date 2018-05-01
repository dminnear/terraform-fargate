variable "project" {
  description = "The name of the project"
}

variable "env" {
  description = "The name of the env"
}

variable "name" {
  description = "The name of the service"
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

variable "alb_subnets" {
  type        = "list"
  description = "The subnets to associate with the ALB"
}

variable "alb_internal" {
  description = "Whether the ALB is internal (true) or public facing (false)"
  default     = false
}

variable "ecs_subnets" {
  type        = "list"
  description = "The public subnets to associate with this service"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

locals {
  name = "${var.project}-${var.env}-${var.name}"
}

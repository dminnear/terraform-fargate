variable "account_id" {
  description = "AWS account ID"
}

variable "profile" {
  description = "AWS profile"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zones" {
  type        = "list"
  description = "AWS AZs"
}

variable "project" {
  description = "The name of this project"
}

variable "env" {
  description = "The name of this environment"
}

variable "vpc_cidr_block" {
  description = "The CIDR block to use in the env specific VPC"
}

variable "backend_image" {
  description = "The docker image to use for the backend"
  default     = "dminnear/terraform-fargate-backend:template-latest"
}

variable "frontend_image" {
  description = "The docker image to use for the frontend"
  default     = "dminnear/terraform-fargate-frontend:template-latest"
}

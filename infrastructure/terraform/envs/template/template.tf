terraform {
  required_version = "= 0.11.7"

  backend "s3" {
    bucket         = "dm-terraform"
    key            = "terraform-fargate/template/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "TerraformLocks"
    profile        = "terraform-fargate"
  }
}

provider "aws" {
  version = "~> 1.16.0"

  region              = "${var.region}"
  allowed_account_ids = ["${var.account_id}"]
  profile             = "${var.profile}"
}

module "network" {
  source = "../../modules/aws/network"

  project                    = "${var.project}"
  env                        = "${var.env}"
  vpc_cidr_block             = "${var.vpc_cidr_block}"
  subnets_availability_zones = "${var.availability_zones}"
}

module "backend" {
  source = "../../modules/aws/services/backend"

  project         = "${var.project}"
  env             = "${var.env}"
  image           = "${var.backend_image}"
  port            = 3000
  private_subnets = ["${module.network.private_subnet_ids}"]
  public_subnets  = ["${module.network.public_subnet_ids}"]
  vpc_id          = "${module.network.vpc_id}"
  vpc_cidr_block  = "${var.vpc_cidr_block}"
}

module "frontend" {
  source = "../../modules/aws/services/frontend"

  project         = "${var.project}"
  env             = "${var.env}"
  image           = "${var.frontend_image}"
  port            = 8080
  private_subnets = ["${module.network.private_subnet_ids}"]
  public_subnets  = ["${module.network.public_subnet_ids}"]
  vpc_id          = "${module.network.vpc_id}"
}

terraform {
  required_version = "= 0.11.7"

  backend "s3" {
    bucket  = "dm-terraform"
    key     = "terraform-fargate/template/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-fargate"
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

data "aws_acm_certificate" "redirect" {
  domain = "redirect.drewminnear.com"
}

module "redirector" {
  source = "../../modules/aws/fargate"

  name                = "redirector"
  project             = "${var.project}"
  env                 = "${var.env}"
  image               = "morbz/docker-web-redirect"
  port                = 80
  cpu                 = 256
  memory              = 512
  alb_subnets         = ["${module.network.public_subnet_ids}"]
  alb_internal        = false
  alb_certificate_arn = "${data.aws_acm_certificate.redirect.arn}"
  ecs_subnets         = ["${module.network.private_subnet_ids}"]
  vpc_id              = "${module.network.vpc_id}"

  environment_variables = {
    REDIRECT_TARGET = "https://www.google.com"
  }
}

data "aws_route53_zone" "redirect" {
  name = "drewminnear.com."
}

resource "aws_route53_record" "redirect" {
  zone_id = "${data.aws_route53_zone.redirect.zone_id}"
  name    = "redirect.drewminnear.com"
  type    = "A"

  alias {
    name                   = "${module.redirector.alb_dns_name}"
    zone_id                = "${module.redirector.alb_zone_id}"
    evaluate_target_health = false
  }
}

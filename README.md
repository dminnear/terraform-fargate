# terraform-fargate

## Purpose of this project

The reason I created this project is to provide a sample
module for using ECS Fargate.

## How to run

1. `./infrastructure/scripts/install-terraform 0.11.7 /usr/local/bin`
1. `cd infrastructure/terraform/envs/template`
1. `terraform init`
1. `terraform apply --auto-approve`

Note that for someone other than me to use this, you'll need to alter the
values in `infrastructure/terraform/envs/template` to resources you
control.

## CPU and Memory Values for Fargate

Fargate requires cpu and memory be specified according
to https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html.

## What does it do

A common problem I run across on projects is redirecting root domains.
For example, from `example.com` to `website.com`. AWS recommends using
S3 websites to redirect, but then https won't work without an annoying
CloudFront setup. With this template project, it would be easy to do this
redirect with a service in ECS Fargate.

(Granted, this project isn't doing a redirect on a root domain. It's
`redirect.drewminnear.com` to `https://www.google.com`.)

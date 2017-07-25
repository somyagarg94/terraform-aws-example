/*
# Upload SSH key which all instances will use.

resource "aws_ssh_key" "default" {
    encoding   = "PEM"
    public_key = "${file("${path.module}/../ssh/cs_ref_arch.pem.pub")}"
} */

provider "aws" {
   region = "${var.aws_region}"
}

module "nodes" {
   source = "./nodes"
  #key_name = $(var.key_name)
}

module "load_balancers" {
    source = "./load_balancers"
}

module "vpc" {
    source = "./vpc"
}
data "aws_vpc" "network" {
  id = "${module.vpc.vpc_id}"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  map_public_ip_on_launch = false

  tags = merge (var.common_tags,
  {
    Name = var.vpc_name
  })
}
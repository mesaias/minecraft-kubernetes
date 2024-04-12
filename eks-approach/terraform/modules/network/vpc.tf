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

  private_subnet_tags = merge (var.common_tags,
  {
    Name                                            = "${var.vpc_name}-vpc-private"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  })
  public_subnet_tags = merge (var.common_tags,
  {
    Name                                            = "${var.vpc_name}-vpc-public"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  })

  tags = merge (var.common_tags,
  {
    Name = var.vpc_name
  })
}

resource "aws_default_security_group" "minecraft_cluster_flow_default_security_group" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}
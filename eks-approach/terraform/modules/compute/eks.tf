#data "aws_eks_cluster" "eks" {
#  name = module.eks.cluster_id
#}
#
#data "aws_eks_cluster_auth" "eks" {
#  name = module.eks.cluster_id
#}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "~> 19.0"
  cluster_version                 = "1.29"
  cluster_name                    = "${var.eks_cluster_name}-eks"
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.public_subnet_ids
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  create_iam_role                 = true
  iam_role_arn                    = var.eks_role_arn
  
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }


  eks_managed_node_groups = {
    minecraft = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["m5a.large"]
      capacity_type  = "SPOT"
    }
  }

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true
  aws_auth_roles            = var.map_roles

  cluster_security_group_additional_rules = {
    ingress_my_ip = {
      description = "My IP"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["148.222.132.53/32"]
    }
  }

  //cloudwatch_log_group_kms_key_id              = aws_kms_key.cloudwatch_eks.arn
  #cloudwatch_log_group_kms_key_id              = module.kms.key_alias_arn
  create_node_security_group                   = true
  node_security_group_enable_recommended_rules = true

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
    ]

  cluster_tags = merge (var.common_tags,
  {
    Name                     = "${var.eks_cluster_name}-eks",
    "karpenter.sh/discovery" = "${var.eks_cluster_name}-cluster-eks-${terraform.workspace}"
  })

}

resource "kubernetes_namespace" "minecraft" {
  metadata {
    name = "minecraft"
  }
}
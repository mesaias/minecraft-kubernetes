data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
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
  subnet_ids                      = var.private_subnet_ids
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }

  eks_managed_node_groups = {

    karpenter_on_demand = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        "platform.raf.io/team"    = "sre"
        "platform.raf.io/part-of" = "core"
      }

      taints = {
        dedicated = {
          key    = "CriticalAddonsOnly"
          effect = "NO_SCHEDULE"
        }
      }

      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

      tags = merge(var.common_tags,
        {
          Name = "${var.eks_cluster_name}-cluster-eks-${terraform.workspace}",
      })
    }
  }
  
  self_managed_node_groups = {
    test = {
      name = "mixed"

      min_size     = 2
      max_size     = 2
      desired_size = 2

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 20
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "t3.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "t3a.small"
            weighted_capacity = "1"
          },
        ]
      }
    }
  }

  create_aws_auth_configmap = false
  manage_aws_auth_configmap = true
  aws_auth_roles            = var.map_roles

  cluster_security_group_additional_rules = {
    ingress_my_ip = {
      description = "My IP"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["149.19.169.119/32"]
    }
  }

  cloudwatch_log_group_kms_key_id              = aws_kms_key.cloudwatch_eks.arn
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

resource "kubernetes_namespace" "applications" {
  metadata {
    name = "applications"
  }
}

resource "kubernetes_service" "nlb_minecraft" {
  metadata {
    name      = "nlb-minecraft-myspot"
    namespace = kubernetes_namespace.applications.metadata.0.name
  }
  spec {
    selector = {
      app = "minecraft-myspot"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 8080
    }
  }
}
application_name="minecraft-server"

vpc_cidr_block="10.1.224.0/24"
vpc_name="minecraft-server-dev-vpc"
availability_zones=["us-east-1a", "us-east-1b"]
public_subnet_cidr=["10.1.224.0/26", "10.1.224.64/26"]
private_subnet_cidr=["10.1.224.128/26", "10.1.224.192/26"]
vpc_flow_logging_role_name="tf-iam-role-vpc-flow-logging"

instance_type_eks="m5.xlarge"
eks_asg_min_size=1
eks_asg_desired_capacity=5
eks_asg_max_size=5

worker_groups=[{
      name                 = "jenkins"
      instance_type        = "r4.xlarge",
      asg_min_size         = 1,
      asg_desired_capacity = 1,
      asg_max_size         = 1,
      kubelet_extra_args   = "--node-labels=node.kubernetes.io/namespace=jenkins"
    },
    {
      name                 = "minecraft"
      instance_type        = "r4.8xlarge",
      asg_min_size         = 1,
      asg_desired_capacity = 1,
      asg_max_size         = 1,
      kubelet_extra_args   = "--node-labels=node.kubernetes.io/namespace=minecraft"
    }
    ]

logs_retention=90

ecr_registries=["minecraft-server"]
ecr_attach_lifecycle_policy=true

eks_cluster_name="minecraft-server-dev"
map_users=[
    {
        userarn  = "arn:aws:iam::000000000:user/isaias.solorio"
        username = "isaias.solorio"
        groups   = ["system:masters"]
    }]
map_roles=[]

self_managed_node_groups = {
    dev = {
      name         = "dev"
      max_size     = 2
      min_size     = 1
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }
      }
    },
  qa = {
    name         = "qa"
      max_size     = 2
      min_size     = 1
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }
      }
  }
}

s3_buckets= []
s3_replication_role_name="tf-iam-role-replication-s3-minecraft-server"


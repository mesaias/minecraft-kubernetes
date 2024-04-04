locals {
  common_tags  = {
    Application = "minecraft_server"
    Environment = terraform.workspace
    Terraform   = "true"
  }

  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.name
  aws_partition = data.aws_partition.current.partition

  kms_eks_identifiers = [
    "arn:aws:iam::${local.account_id}:root",
    "arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/*"
    ]
}

variable application_name {
    type    = string
    default = "minecraft-server"
}

variable vpc_cidr_block {
    type    = string
    default = "10.1.224.0/19"
}

variable vpc_name {
    type    =   string
    default = "minecraft-server-dev-vpc"
}

variable "availability_zones" {
    type        = list
    description = "The AWS AZ to deploy all inside of VPC"
}

variable "private_subnet_cidr" {
    type        = list
    description = "Private Subnet CIDR for the network"
}

variable "public_subnet_cidr" {
    type        = list
    description = "Public Subnet CIDR for the network"
}

variable "vpc_flow_logging_role_name" {
  type = string
  description = "the vpc flow name base"
}

variable "logs_retention" {
  type    = number
  default = 90
}

variable "ecr_registries" {
  type = list
  description = "Docker images registries for minecraft server on eks"
}

variable "ecr_attach_lifecycle_policy" {
  type    = bool
  default = true
}

variable "eks_cluster_name" {
  default = "minecraft-server-dev"
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = list(object({
                  userarn  = string,
                  username = string,
                  groups   = list(string)    
                  }))
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap"
  type        = list(object({
                  rolearn  = string,
                  username = string
                  groups   = list(string)
  }))
}

/*variable "worker_groups" {
  type    = list(object({
          name                 = string,
          instance_type        = string,
          asg_min_size         = string,
          asg_desired_capacity = number,
          asg_max_size         = number,
          kubelet_extra_args   = string    
        }))
}*/

variable "self_managed_node_groups" {
  type = map(any)
}

variable "engine_rds_postgres" {
  description = "the value for engine of RDS"
  type = string
  default = "postgres"
}
variable "engine_version_rds_postgres" {
  description = "version of engine for RDS with postgres"
  type = string
  default = "11.13"
}

variable "instance_class_rds_postgres" {
  description = "version of engine for RDS with postgres"
  type = string
  default = "db.t3.medium"
}
variable "allocated_storage_rds_postgres" {
  description = "instance size for rds with postgres"
  type = string
  default = "db.t3.medium"
}

variable "s3_buckets" {
  description = "list of buckets for minecraft in the cluster"
  type = list
}

variable "s3_replication_role_name" {
  type = string
  description = "the s3 replication role base name"
}

variable "instance_type_eks" {
    default     = "t3.medium"
    type        = string
    description = "the type of the instance or node from eks cluster" 
}

variable "eks_asg_min_size" {
  default = 5
  type    = number
}

variable "eks_asg_desired_capacity" {
  default = 5
  type    = number
}

variable "eks_asg_max_size" {
  default = 5
  type    = number
}

variable "worker_groups" {
  type    = list(object({
          name                 = string,
          instance_type        = string,
          asg_min_size         = string,
          asg_desired_capacity = number,
          asg_max_size         = number,
          kubelet_extra_args   = string    
        }))
}
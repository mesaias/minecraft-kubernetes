locals {
  common_tags  = {
    Application = "minecraft_server"
    Environment = terraform.workspace
    Terraform   = "true"
  }

  account_id    = data.aws_caller_identity.current.account_id
  aws_region    = data.aws_region.current.name
  aws_partition = data.aws_partition.current.partition
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
    type    = string
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

variable "ecr_minecraft_server_registries" {
  type = list
  description = "Docker images registries for minecraft server on eks"
}

variable "s3_buckets" {
  description = "list of buckets for minecraft in the cluster"
  type = list
}

variable "s3_replication_role_name" {
  type = string
  description = "the s3 replication role base name"
}

variable "ami" {
  type    = string
  default = "ami-06214aeeff0d25699"
}
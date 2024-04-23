module "network" {
    source                    = "./modules/network"
    vpc_cidr_block            = var.vpc_cidr_block
    vpc_name                  = var.vpc_name
    availability_zones        = var.availability_zones
    public_subnet_cidr        = var.public_subnet_cidr
    private_subnet_cidr       = var.private_subnet_cidr
    eks_cluster_name          = var.eks_cluster_name
    logs_retention            = var.logs_retention
    application_name          = var.application_name
    common_tags               = local.common_tags
}

module "iam" {
    source                     = "./modules/iam"
    vpc_flow_logging_role_name = var.vpc_flow_logging_role_name
    s3_replication_role_name   = var.s3_replication_role_name
}

module "compute" {
    source                   = "./modules/compute"
    private_subnet_cidr      = var.private_subnet_cidr
    eks_cluster_name         = var.eks_cluster_name
    instance_type_eks        = var.instance_type_eks
    map_users                = var.map_users
    map_roles                = var.map_roles
    eks_asg_min_size         = var.eks_asg_min_size
    eks_asg_desired_capacity = var.eks_asg_desired_capacity
    eks_asg_max_size         = var.eks_asg_max_size
    worker_groups            = var.worker_groups
    aws_region               = local.aws_region
    vpc_id                   = module.network.vpc_id
    private_subnet_ids       = module.network.private_subnet_ids
    public_subnet_ids        = module.network.public_subnet_ids
    eks_role_arn             = module.iam.eks_role_arn
    common_tags              = local.common_tags
    account_id               = local.account_id
    kms_eks_identifiers      = local.kms_eks_identifiers
}

module "ecr" {
    source                      = "./modules/ecr"
    ecr_registries              = var.ecr_registries
    ecr_attach_lifecycle_policy = var.ecr_attach_lifecycle_policy
}

/*module "logging" {
    source           = "./modules/logging"
    application_name = var.application_name
    account_id       = local.account_id
    aws_region       = local.aws_region
    aws_partition    = local.aws_partition
}*/
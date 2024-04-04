module "network" {
    source                    = "./modules/network"
    vpc_cidr_block            = var.vpc_cidr_block
    vpc_name                  = var.vpc_name
    availability_zones        = var.availability_zones
    public_subnet_cidr        = var.public_subnet_cidr
    private_subnet_cidr       = var.private_subnet_cidr
    logs_retention            = var.logs_retention
    application_name          = var.application_name
    vpc_flow_logging_role_arn = module.iam.vpc_flow_logging_role_arn
    common_tags               = local.common_tags
}

module "iam" {
    source                     = "./modules/iam"
    vpc_flow_logging_role_name = var.vpc_flow_logging_role_name
    s3_replication_role_name   = var.s3_replication_role_name
    application_name           = var.application_name
}

module "compute" {
    source                        = "./modules/compute"
    application_name              = var.application_name
    ami                           = var.ami
    private_subnet_ids            = module.network.private_subnet_ids
    sg_control_plane              = module.network.sg_control_plane
    sg_kubernetes_node_asg        = module.network.sg_kubernetes_node_asg
    kubernetes_node_role          = module.iam.kubernetes_node_role
    kubernetes_control_plane_role = module.iam.kubernetes_control_plane_role
    common_tags                   = local.common_tags
}

module "logging" {
    source           = "./modules/logging"
    application_name = var.application_name
    account_id       = local.account_id
    aws_region       = local.aws_region
    aws_partition    = local.aws_partition
}
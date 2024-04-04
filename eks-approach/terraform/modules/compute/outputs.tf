output "worker_security_group_id" {
    value = module.eks.cluster_primary_security_group_id
}
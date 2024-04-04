output "replication_s3_role_arn" {
    value = aws_iam_role.replication_s3.arn
}

output "vpc_flow_logging_role_arn" {
    value = aws_iam_role.vpc_flow_logging_minecraft.arn
}

output "kubernetes_node_role" {
    value = aws_iam_role.kubernetes_node_role.name
}

output "kubernetes_control_plane_role" {
    value = aws_iam_role.kubernetes_control_plane_role_minecraft.name
}
output "replication_s3_role_arn" {
    value = aws_iam_role.replication_s3.arn
}

output "eks_role_arn" {
    value = aws_iam_role.eks_policy.arn
}
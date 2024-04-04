output "replication_s3_role_arn" {
    value = aws_iam_role.replication_s3.arn
}

output "vpc_flow_logging_role_arn" {
    value = aws_iam_role.vpc_flow_logging.arn
}
resource "aws_iam_role" "replication_s3" {
  name               = "${var.s3_replication_role_name}_${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies_json/replication_s3.json")
}

resource "aws_iam_role" "eks_policy" {
  name               = "eks-${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = [aws_iam_policy.eks_policy.arn]
}
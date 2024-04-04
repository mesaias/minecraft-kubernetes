resource "aws_kms_key" "cloudwatch_eks" {
  description         = "This key is used to encrypt cloudwatch group"
  is_enabled          = true
  enable_key_rotation = true

  tags = merge(var.common_tags,
    {
      Name = "aws/cloudwatch_group_eks"
      Tier = "Data"
  })
}

resource "aws_kms_key_policy" "cloudwatch_policy" {
  key_id = aws_kms_key.cloudwatch_eks.id
  policy = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "kms_policy" {

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow access through eks for all principals in the account that are authorized to use eks"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com", "logs.${var.aws_region}.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.aws_region}:${var.account_id}:*"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5"

  aliases               = ["eks/${var.eks_cluster_name}-cluster-${terraform.workspace}"]
  description           = "${var.eks_cluster_name}-${terraform.workspace} cluster encryption key"
  enable_default_policy = true
  key_owners = var.kms_eks_identifiers

  tags = merge(var.common_tags,
    {
      Name = "eks/${var.eks_cluster_name}"
  })
}
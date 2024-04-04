resource "aws_iam_role" "replication_s3" {
  name               = "${var.s3_replication_role_name}_${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies_json/replication_s3.json")
}

resource "aws_iam_role" "vpc_flow_logging_minecraft" {
    name               = "${var.application_name}-${var.vpc_flow_logging_role_name}-${terraform.workspace}"
    assume_role_policy = file("${path.module}/policies_json/vpc_flow_logging.json")
}

resource "aws_iam_role" "kubernetes_node_role" {
  name               = "kubernetes-node-role"
  assume_role_policy = file("${path.module}/policies_json/kubernetes_node_role_policy.json")
}

resource "aws_iam_policy_attachment" "kubernetes_node_policy_attachment" {
  name       = "${var.application_name}-kubernetes-node-policy-attachment-${terraform.workspace}"
  policy_arn = aws_iam_policy.kubernetes_node_policy_minecraft.arn
  roles      = [aws_iam_role.kubernetes_node_role.name]
}

resource "aws_iam_role" "kubernetes_control_plane_role_minecraft" {
  name               = "${var.application_name}-kubernetes-control-plane-role-${terraform.workspace}"
  assume_role_policy = file("${path.module}/policies_json/kubernetes_control_plane_assume_role.json")
}

resource "aws_iam_policy_attachment" "kubernetes_control_plane_policy_attachment_minecraft" {
  name       = "${var.application_name}-kubernetes-control-plane-policy-attachment-${terraform.workspace}"
  policy_arn = aws_iam_policy.kubernetes_control_plane_policy_minecraft.arn
  roles      = [aws_iam_role.kubernetes_control_plane_role_minecraft.name]
}
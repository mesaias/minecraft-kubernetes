resource "aws_iam_role_policy" "vpc_flow_logging_minecraft" {
  name   = "${var.application_name}-vpc-flow-logging-${terraform.workspace}"
  role   = aws_iam_role.vpc_flow_logging_minecraft.id
  policy = file("${path.module}/policies_json/vpc_flow_logging.json")
}

resource "aws_iam_policy" "kubernetes_node_policy_minecraft" {
  name        = "${var.application_name}-kubernetes-node-policy-${terraform.workspace}"
  description = "IAM policy for Kubernetes cluster nodes"
  
  policy = file("${path.module}/policies_json/kubernetes_policy.json")
}

resource "aws_iam_policy" "kubernetes_control_plane_policy_minecraft" {
  name        = "${var.application_name}-kubernetes-control-plane-policy-${terraform.workspace}"
  description = "IAM policy for Kubernetes control plane"
  
  policy = file("${path.module}/policies_json/kubernetes_control_plane_policy.json")
}
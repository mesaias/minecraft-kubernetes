resource "aws_iam_role_policy" "vpc_flow_logging" {
  name   = "vpc_flow_logging"
  role   = aws_iam_role.vpc_flow_logging.id
  policy = file("${path.module}/policies_json/vpc_flow_logging.json")
}
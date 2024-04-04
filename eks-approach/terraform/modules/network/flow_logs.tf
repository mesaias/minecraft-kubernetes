module "vpc_flow_logs" {
  source = "trussworks/vpc-flow-logs/aws"

  vpc_name       = var.vpc_name
  vpc_id         = data.aws_vpc.network.id
  logs_retention = var.logs_retention
}
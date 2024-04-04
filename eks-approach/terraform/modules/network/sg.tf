resource "aws_security_group" "alb_sg_minecraft_server" {
  name        = "alb-${var.application_name}"
  description = "Security group for alb for minecraft server"
  vpc_id      = data.aws_vpc.network.id

  tags = merge(var.common_tags,
    {
      Name = "alb-${var.application_name}"
  })
}

resource "aws_security_group_rule" "alb_ingress_minecraft_server_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SG for open the 80 port to internet"

  security_group_id = aws_security_group.alb_sg_minecraft_server.id
}

resource "aws_security_group_rule" "alb_ingress_minecraft_server_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SG for open the 443 port to internet"

  security_group_id = aws_security_group.alb_sg_minecraft_server.id
}
resource "aws_security_group" "alb_sg_minecraft_server" {
  name        = "alb-${var.application_name}"
  description = "Security group for alb for minecraft server"
  vpc_id      = data.aws_vpc.network.id

  tags = merge(var.common_tags,
    {
      Name = "alb-${var.application_name}"
  })
}

resource "aws_security_group_rule" "lb_ingress_minecraft_server" {
  type        = "ingress"
  from_port   = 30565
  to_port     = 30565
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SG for open the 30565 port to internet"

  security_group_id = aws_security_group.alb_sg_minecraft_server.id
}

resource "aws_security_group" "kubernetes_control_plane_sg" {
  name        = "${var.application_name}-kubernetes-control-plane-sg"
  description = "Security group for Kubernetes control plane"

  vpc_id = data.aws_vpc.network.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443  # Kubernetes API server
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kubernetes_node_sg" {
  name        = "${var.application_name}-kubernetes_node_sg-${terraform.workspace}"
  description = "Security group for Kubernetes cluster nodes"

  vpc_id = data.aws_vpc.network.id

  ingress {
    from_port   = 0  # Allow all traffic within the security group (node-to-node communication)
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port   = 0  # Allow traffic from the control plane (Kubernetes API server)
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.kubernetes_control_plane_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
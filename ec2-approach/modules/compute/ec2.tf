module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.application_name}-control-plane-instance"

  instance_type          = "t2.micro"
  key_name               = "${var.application_name}-control-plane"
  monitoring             = true
  vpc_security_group_ids = [var.sg_control_plane]
  subnet_id              = element(var.private_subnet_ids, 0)
  iam_instance_profile   = var.kubernetes_control_plane_role
  ami                    = var.ami

  tags = merge(var.common_tags,
        {
          Name = "${var.application_name}-control-plane-instance-${terraform.workspace}",
    })
}
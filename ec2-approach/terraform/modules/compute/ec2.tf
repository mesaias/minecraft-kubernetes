resource "aws_instance" "control-plane-instance" {
  key_name               = "${var.application_name}-control-plane"
  ami                    = var.ami
  instance_type          = "t3.micro"
  monitoring             = true
  vpc_security_group_ids = [var.sg_control_plane]
  subnet_id              = element(var.private_subnet_ids, 0)

  tags = merge(var.common_tags,
        {
           Name = "${var.application_name}-control-plane-instance-${terraform.workspace}",
    })
}

resource "aws_instance" "jenkins" {
  key_name               = "${var.application_name}-jenkins"
  ami                    = var.ami
  instance_type          = "t3.micro"
  monitoring             = true
  vpc_security_group_ids = [var.sg_jenkins]
  subnet_id              = element(var.private_subnet_ids, 0)

  tags = merge(var.common_tags,
        {
          Name = "${var.application_name}-jenkins-${terraform.workspace}",
    })
}
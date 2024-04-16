resource "aws_launch_configuration" "kubernetes_node_launch_conf" {
  name_prefix                 = "kube_node_launch_conf-"
  image_id                    = var.ami
  instance_type               = "t2.micro"
  key_name                    = "${var.application_name}-worker-nodes"
  security_groups             = [var.sg_kubernetes_node_asg]
  associate_public_ip_address = false
  iam_instance_profile        = var.kubernetes_node_role

  root_block_device {
    encrypted     = true
  }

  metadata_options {
      http_endpoint = "enabled"
      http_tokens   = "required"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "kubernetes_node_launch_template" {
  image_id      = var.ami
  instance_type = "t2.micro"

  tags = merge (var.common_tags,
  {
    Name                     = "${var.application_name}-kubernetes-node-launch-template"
  })
}

resource "aws_autoscaling_group" "kubernetes_node_asg" {
  name                 = "${var.application_name}-kubernetes_node_asg-${terraform.workspace}"
  launch_configuration = resource.aws_launch_configuration.kubernetes_node_launch_conf.name
  min_size             = 2
  max_size             = 5
  desired_capacity     = 4
  vpc_zone_identifier  = var.private_subnet_ids

   launch_template {
    id      = aws_launch_template.kubernetes_node_launch_template.id
    version = aws_launch_template.kubernetes_node_launch_template.latest_version
  }

  tag {
   
    key                 = "${var.application_name}-worker-nodes"
    value               = "${var.application_name}-worker-nodes"
    propagate_at_launch = true
  }
}
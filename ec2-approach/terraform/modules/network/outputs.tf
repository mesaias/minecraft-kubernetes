output "vpc_id" {
    value = module.vpc.vpc_id
}

output "private_subnet_ids" {
    value = module.vpc.private_subnets
}

output "public_subnet_ids" {
    value = module.vpc.public_subnets
}

output "sg_control_plane" {
    value = aws_security_group.kubernetes_control_plane_sg.id
}

output "sg_kubernetes_node_asg" {
    value = aws_security_group.kubernetes_node_sg.id
}
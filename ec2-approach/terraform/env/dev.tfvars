application_name="minecraft-server"

vpc_cidr_block="10.1.224.0/24"
vpc_name="minecraft-server-dev-vpc"
availability_zones=["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidr=["10.1.224.0/26", "10.1.224.64/26"]
private_subnet_cidr=["10.1.224.128/26", "10.1.224.192/26"]
vpc_flow_logging_role_name="tf-iam-role-vpc-flow-logging"

logs_retention=90
ecr_minecraft_server_registries=["minecraft-server-eks"]

s3_buckets= []
s3_replication_role_name="tf-iam-role-replication-s3-minecraft-server"

ami="ami-06214aeeff0d25699"
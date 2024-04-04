Minecraft Server in Kubernetes
==============

Go to eks-approach or ec2-approach folder and run
```bash
terraform plan -var-file=env/dev.tfvars -out tf.plan
terraform show -json tf.plan  > tf.json 
checkov -f tf.json
```

Or in the same step

```bash
terraform plan -var-file=env/dev.tfvars -out tf.plan && terraform show -json tf.plan  > tf.json && checkov -f tf.json
```

There 2 folders with Dockerfiles (Dockerfile-terraform and Dockerfile-trivy) that are necessaries for use them like Jenkins Agents


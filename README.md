Minecraft Server in Kubernetes
==============

### Prerequisites 
* kubectl
* helm
* ansible client
* docker
* checkov
* draw.io

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

### Folders 
* There are 2 folders with Dockerfiles (Dockerfile-terraform and Dockerfile-trivy) that are necessaries for use them like Jenkins Agents

* jenkins - The yaml files necessaries for run the helm commands for install, upgrade or delete jenkins on Kubernetes. Also, there is a sh file for see the sh commands

* monitoring - All the yaml files for install grafana and prometheus with helm on kubernetes.
Also, there is a sh file for see the sh commands
aws eks describe-addon-versions --addon-name aws-ebs-csi-driver

eksctl create addon --name aws-ebs-csi-driver --cluster minecraft-server-dev-eks --service-account-role-arn arn:aws:iam::638453533211:role/AmazonEKS_EBS_CSI_DriverRole --force

aws iam create-role --role-name AmazonEKS_EBS_CSI_DriverRole --assume-role-policy-document file://"AmazonEKS_EBS_CSI_DriverRole .json"

aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --role-name AmazonEKS_EBS_CSI_DriverRole

helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver


helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver

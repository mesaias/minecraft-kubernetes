pipeline {

  agent { kubernetes { inheritFrom 'terraform' } }

  parameters {
    choice(
      name: 'options', 
      choices: ['EC2', 'EKS'], 
      description: 'Select what kind of infrastructure to launch'
      )
  }

  stages {
    stage('Init, plan and checkov') {
      steps {
          container('terraform-alpine') {
            script {
                def path = ''
                if (params.options == 'EC2' ) {
                    path = 'ec2-approach'
                } else {
                    path = 'eks-approach'
                }
                withAWS(credentials: 'personal', region: 'us-east-1') {
                        sh "cd ${path}/terraform && terraform init"
                        sh "cd ${path}/terraform && terraform plan -var-file=env/dev.tfvars -out tf.plan && terraform show -json tf.plan"
                }
            }
        }
      }
    }

    stage('Finish') {
      steps {
        print("This is the end")
      }
    }
  }
}
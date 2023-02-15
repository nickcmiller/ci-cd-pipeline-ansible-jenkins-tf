pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
    }
    stages {
        stage('Init') {
            steps {
                sh 'ls'
                sh 'terraform init -no-color'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -no-color'
            }
        }
        stage('Apply') {
            steps {
                sh 'terraform apply -auto-approve -no-color'
            }
        }
        stage('Wait') {
            steps {
                sh 'aws ec2 wait instance-status-ok --region us-east-1'
            }
        }
        stage('Test SSH') {
            steps {
                sh "aws ec2 describe-instances --region us-east-1 --filters \"Name=tag:Name,Values=main-instance-*\" --query 'Reservations[].Instances[].PublicIpAddress' --output text"
                sh "MAIN_IP=\$(aws ec2 describe-instances --region us-east-1 --filters \"Name=tag:Name,Values=main-instance-*\" --query 'Reservations[].Instances[].PublicIpAddress' --output text)"
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh "ssh -i $SSH_KEY ec2-user@$MAIN_IP"
                }
            }
        }
        stage('Ansible') {
            steps {
                ansiblePlaybook(
                    playbook: 'playbooks/main-playbook.yml',
                    inventory: 'aws_hosts',
                    credentialsId: 'ec2-ssh-key'
                )
            }
        }
        stage('Destroy') {
            steps {
                sh 'terraform destroy -auto-approve -no-color'
            }
        }
    }
}
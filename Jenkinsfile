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
                def MAIN_IP = sh(script: "aws ec2 describe-instances --region us-east-1 --filters 'Name=tag:Name,Values=main-instance-*' --query 'Reservations[].Instances[].PublicIpAddress' --output text", returnStdout: true).trim()
                sh "ssh -i /home/ec2-user/.ssh/main_key ec2-user@${MAIN_IP}"
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
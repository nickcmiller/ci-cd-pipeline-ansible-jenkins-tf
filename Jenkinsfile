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
        stage('Ansible'){
            steps {
                sh 'cat aws_hosts'
                sh 'ansible-playbook -i aws_hosts --key-file /home/ec2-user/.ssh/main_key playbooks/main-playbook.yml'
            }
        }
        stage('Destroy') {
            steps {
                sh 'terraform destroy -auto-approve -no-color'
            }
        }
    }
}
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
                sh """#!/bin/bash
                    MAIN_IP=\$(aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Name,Values=main-instance-*" --query 'Reservations[].Instances[].PublicIpAddress' --output text)
                    echo \$MAIN_IP
                    ssh-keyscan \$MAIN_IP >> ~/.ssh/known_hosts
                    ssh -i /home/ec2-user/.ssh/main_key ec2-user@\$MAIN_IP
                    pwd
                    whoami
                    curl https://ifconfig.me
                    
                """
            }
        }
        stage('Ansible') {
            steps {
                sh """
                    MAIN_IP=\$(aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Name,Values=main-instance-*" --query 'Reservations[].Instances[].PublicIpAddress' --output text)
                    echo \$MAIN_IP
                    ssh-keyscan \$MAIN_IP >> ~/.ssh/known_hosts
                    ansible-playbook playbooks/main-playbook.yml \
                    --inventory aws_hosts
                    --private-key /home/ec2-user/.ssh/main_key \
                    --user ec2-user
                """
            }
        }
        stage('Destroy') {
            steps {
                sh 'terraform destroy -auto-approve -no-color'
            }
        }
    }
}
pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        SSH_CREDENTIALS = credentials('ec2-ssh-key')
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
        stage('Ansible') {
            steps {
                sshagent(['$SSH_CREDENTIALS']) {
                    ansiblePlaybook(
                            playbook: 'playbooks/main-playbook.yml',
                            inventory: 'aws_hosts',
                            extraVars: [
                                'ansible_ssh_common_args': '-o StrictHostKeyChecking=no'
                            ]
                    )
                }
            }
        }
        stage('Destroy') {
            steps {
                sh 'terraform destroy -auto-approve -no-color'
            }
        }
    }
}
## Project Overview

Building a pipeline with Ansible, Terraform, and Jenkins.

## Setting up the Cloud9

### Resize Host 

* Run `cloud9-resize.sh` in `notes` to ensure you have enough disk space when doing this project

### Install Ansible on host



## Terraform Portion of Project

Below is a synopsis of what the Terraform files deploy.

### Setup VPC and Network

* Sets up a VPC, IGW, route table, and private and public routes
* Set up public subnet

### Security Setup

* Configure Security Groups and Security Group Rules
* Make an RSA Key Pair

#### Creating an RSA Key and Key Pair

* Run these Linux commands in terminal:
    ```
    #Generate Key
    ssh-keygen -t rsa
    
    #Save it to the root Terraform folder when prompted
    Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa): /home/ec2-user/.ssh/main_key       
    
    #Next leave these empty on the following prompts as we don't want a passphrase
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again:
    ```
* Create variable names for the key name and the key path in terraform.tfvars file to use for later:
    ```
    key_name="main_key"
    public_key_path= "/home/ec2-user/.ssh/main_key"
    ```

### Deploy first EC2 Instance

#### Configure EC2 Resource

* Use `aws_ami` **data** resource to look up ami to use for instance
* Use the `main_security_group` and the first **public subnet** with the instance
* Create `random_id` resource that can be appended to instance tags
* Scale up the instances with the use of `count` in the instance

#### Setup the user Data Template

* Installs Grafana and gets it running

#### Configure `local-exec`

* Save host names in a text file called aws_hosts
* Check the status of the instance being deployed and wait until it reaches "ok" status

## Ansible

### Install Ansbile on Centos

To get Ansible for CentOS 7, first ensure that the CentOS 7 EPEL repository is installed:

`sudo yum install epel-release`

Once the repository is installed, install Ansible with yum:

`sudo yum install ansible`

Test that it is setup correctly with: 
`ansible localhost -m ping`

### Ad Hoc Commands

Intro guide can be founder here: https://docs.ansible.com/ansible/2.5/user_guide/intro_adhoc.html

Builtin modules can be found here: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html

### Preparing Ansible to run on localhost

We're going to need to make some host changes to run Ansible locally. You'll need to use `sudo vim`.

In `/etc/ansible/ansible.cfg`, use change this value like so `host_key_checking = False` to disable checking of host key of an SSH connection before connecting to it. This is a less secure setting but is useful for this lab.
Still within the .cfg file, you'll also want to change `retry_files_enables=true` and set the retry save path to the host `retry_files_save_path = ~/environment/ci-cd-pipeline-ansible-jenkins-tf/.ansible-retry`

In `/etc/ansible/hosts`, add the following to the top of the file:
```
[hosts]
localhost
[host:vars]
ansible_connection=local ansible_python_interpreter=/usr/bin/python3

```
### Ansible Playbooks

#### Ansible Jenkins Setup for Local Host (Deployment Node)

* Setting up Jenkins on host where Terraform and Ansible will be run

#### Ansible Create File for Main Nodes (playbooks/main-playbook.yml)

* Download the RPM Key for Grafana and add Grafana Repo to host
* Update cache and install Grafana
* Start Grafana and enable it for future reboots
* Download Prometheus
* Create Prometheus Groups and Users
* Create Prometheus Directories using an Ansible loop
* Copy files using an Ansible loop

#### Ansible Destroy File (playbooks/grafana-destroy.yml)

* Undo the installation process

## Jenkins

### Integrate Jenkins with Github

Reference: https://github.com/jenkinsci/github-branch-source-plugin/blob/master/docs/github-app.adoc

openssl pkcs8 -topk8 -inform PEM -outform PEM -in key-in-your-downloads-folder.pem -out converted-github-app.pem -nocrypt

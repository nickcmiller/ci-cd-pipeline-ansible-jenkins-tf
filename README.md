## Project Overview

Building a pipeline with Ansible, Terraform, and Jenkins.

## Terraform Portion of Project

Below is a synopsis of what they Terraform files deploy.

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
    
    #Next type in the passphrase on the following prompts
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again:
    ```
* Create variable names for the key name and the key path in terraform.tfvars file to use for later:
    ```
    key_name="main_key"
    public_key_path= "/home/ec2-user/.ssh/main_key"
    ```
* 

### Deploy first EC2 Instance

#### Configure EC2 Resource

* Use `aws_ami` **data** resource to look up ami to use for instance
* Use the `main_security_group` and the first **public subnet** with the instance
* Create `random_id` resource that can be appended to instance tags
* Scale up the instances with the use of `count` in the instance

#### Setup the user Data Template
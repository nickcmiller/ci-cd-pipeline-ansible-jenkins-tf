## Project Overview

Building a pipeline with Ansible, Terraform, and Jenkins


## Terraform Portion of Project

### Setup VPC and Network
* Sets up a VPC, IGW, route table, and private and public routes
* Set up public subnet

* 
### Security Setups
* Configure Security Groups and Security Group Rules
* Make an RSA Key Pair

#### Creating an RSA Key
```
#Print working directory of root Terraform folder
pwd

#Generate Key
ssh keygen -t rsa

#Save it to the root Terraform folder when prompted

```
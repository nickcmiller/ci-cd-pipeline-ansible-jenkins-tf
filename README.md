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

#### Creating an RSA Key and Key Pair
```
#Print working directory of root Terraform folder
pwd

#Generate Key
#Save it to the root Terraform folder when prompted
ssh keygen -t rsa

```

###Deploy first EC2 Instance

* Use `aws_ami` **data** resource to look up ami to use for instance
* Use the `main_security_group` and the first **public subnet** with the instance
resource "random_id" "main_instance_random" {
    count = var.main_instance_count
    byte_length = 3
    
}

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["137112412989"]
    
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*"]
    }
}

resource "aws_key_pair" "main_key_pair" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}

resource "aws_instance" "main_instance" {
    count = var.main_instance_count
    instance_type = var.main_instance_type
    ami = data.aws_ami.server_ami.id
    key_name = aws_key_pair.main_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.main_security_group.id]
    subnet_id = aws_subnet.main_public_subnet[count.index].id
    root_block_device {
        volume_size = var.main_vol_size
    }
    user_data = templatefile("./main-userdata.tpl", {new_hostname = "main-instance-${random_id.main_instance_random[count.index].dec}"})
    tags = {
        Name = "main-instance-${random_id.main_instance_random[count.index].dec}" 
    }
    
    provisioner "local-exec" {
        command = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region us-east-1"
    }
    
    provisioner "local-exec" {
        when = destroy
        command = "sed -i '/^[0-9]/d' aws_hosts && sed '/^ *$/d' aws_hosts"
    }
}

# resource "null_resource" "grafana_install" {
#     depends_on = [aws_instance.main_instance]
#     provisioner "local-exec" {
#         command = "ansible-playbook -i aws_hosts --key-file /home/ec2-user/.ssh/main_key playbooks/main-playbook.yml"
#     }
# }

output "grafana_access" {
    value = {for i in aws_instance.main_instance[*] : i.tags.Name => "${i.public_ip}:3000"}
}
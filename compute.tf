resource "random_id" "main_instance_random" {
    count = var.main_instance_count
    byte_length = 3
    
}

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
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
    vpc_security_group_ids = [aws_security_group.main_security_group.id]
    subnet_id = aws_subnet.main_public_subnet[count.index].id
    root_block_device {
        volume_size = var.main_vol_size
    }
    
    tags = {
        Name = "main-instance-${random_id.main_instance_random[count.index].dec}" 
    }
}
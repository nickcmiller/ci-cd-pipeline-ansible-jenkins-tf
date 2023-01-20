#root/variables.tf

variable vpc_cidr {
    type = string
    default = "10.123.0.0/16"
}

variable access_ip {
    type = string
    default = "0.0.0.0/0"
}


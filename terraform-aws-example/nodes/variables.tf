
variable instance_type {
    description = "Instance type"
    default     = "t2.micro"
}

# Ubuntu Precise 16.04 LTS (x64)
variable aws_ami {
    description = "Name of the amis to use"
    default = "ami-8b92b4ee" 
}

variable bastion_count {
    description = "Name of the kubernetes bastion node"
    default = 1
}

variable master_count {
  description = "Number of k8s master nodes"
  default     = 1
}

variable ingress_count {
    description = "Name of the kubernetes ingress node"
    default = 1
}

variable etcd_count {
    description = "Name of the kubernetes etcd node"
    default = 1
}

variable worker_count {
    description = "Name of the kubernetes worker node"
    default = 1
}


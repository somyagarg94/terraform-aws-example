# Create the Kubernetes worker nodes 

resource "aws_security_group" "worker-dmz" {
  name          = "worker-dmz"
  description   = "Worker security group."

  ingress {
      from_port = 0
      to_port = 6666
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "0"
      cidr_blocks = ["0.0.0.0/0"]
  }

    vpc_id        = "vpc-eb870d82"
}

resource "aws_instance" "worker_node" {
  instance_type                 = "${var.instance_type}"
  count                         = "${var.worker_count}"
  vpc_security_group_ids        = [ "${aws_security_group.worker-dmz.id}" ]
  associate_public_ip_address   = true
  #user_data                     = "${file("../../shared/user-data.txt")}"
  tags {
        Name = "worker_node-${count.index + 1}"
       }
  ami                           = "${var.aws_ami}"
  subnet_id                     = "subnet-5e23ba37"
  key_name                      = "cs_ref_arch"

}
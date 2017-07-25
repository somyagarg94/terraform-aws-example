# Create the Kubernetes etcd nodes 

resource "aws_security_group" "etcd-dmz" {
  name          = "etcd-dmz"
  description   = "etcd security group."

  ingress {
      from_port = 0
      to_port = 2380
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 6660
      protocol = "0"
      cidr_blocks = ["0.0.0.0/0"]
  }

       vpc_id        = "vpc-eb870d82"

}

resource "aws_instance" "etcd_node" {
  instance_type                 = "${var.instance_type}"
  count                         = "${var.etcd_count}"
  vpc_security_group_ids        = [ "${aws_security_group.etcd-dmz.id}" ]
  associate_public_ip_address   = true
  #user_data                     = "${file("../../shared/user-data.txt")}"
  tags {
        Name = "etcd_node-${count.index + 1}"
       }
  ami                           = "${var.aws_ami}"
  subnet_id                     = "subnet-5e23ba37"
  key_name                      = "cs_ref_arch"

}
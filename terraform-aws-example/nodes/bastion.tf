
# Create the Kubernetes bastion nodes 

resource "aws_security_group" "bastion-dmz" {
  name          = "bastion-dmz"
  description   = "Test security group3."

  ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }

  egress {
            from_port = 22
            to_port = 22
            protocol = "0"
            cidr_blocks = ["0.0.0.0/0"]
         }

       vpc_id        = "vpc-eb870d82"

}

resource "aws_instance" "bastion_node" {
    connection {
                    type            = "ssh"
                    user            = "ubuntu"
                    private_key     = "${file("${path.module}/../ssh/cs_ref_arch")}"
                    timeout         = "2m"
               }

  instance_type                      = "${var.instance_type}"
  count                              = "${var.bastion_count}"
  vpc_security_group_ids             = [ "${aws_security_group.bastion-dmz.id}" ]
  associate_public_ip_address        = true
  #user_data                          = "${file("../../shared/user-data.txt")}"
  tags {
        Name = "bastion_node-${count.index + 1}"
       }
  ami                                = "${var.aws_ami}"
  subnet_id                          = "subnet-5e23ba37"
  key_name                      = "cs_ref_arch"
}
# Create the Kubernetes ingress nodes 

resource "aws_security_group" "ingress-dmz" {
  name          = "ingress-dmz"
  description   = "Ingress security group."

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

resource "aws_instance" "ingress_node" {
  instance_type                 = "${var.instance_type}"
  count                         = "${var.ingress_count}"
  vpc_security_group_ids        = [ "${aws_security_group.ingress-dmz.id}" ]
  associate_public_ip_address   = true
 # user_data                     = "${file("../../shared/user-data.txt")}"
  tags {
        Name = "ingress_node-${count.index + 1}"
       }
  ami                           = "${var.aws_ami}"
  subnet_id                     = "subnet-5e23ba37"
  key_name                      = "cs_ref_arch"

}
# Create the Kubernetes master nodes 
resource "aws_key_pair" "cs_ref_arch_key" {
  key_name = "cs_ref_arch"
  public_key = "${file("${path.module}/../ssh/cs_ref_arch.pub")}"
}

resource "aws_security_group" "master-dmz" {
  name          = "master-dmz"
  description   = "Test security group2."

  ingress {
            from_port = 0
            to_port = 2379
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }

  egress {
            from_port = 0
            to_port = 6666
            protocol = "0"
            cidr_blocks = ["0.0.0.0/0"]
         }

       vpc_id        = "vpc-eb870d82"
}

resource "aws_instance" "master_node" {
  instance_type                 = "${var.instance_type}"
  count                         = "${var.master_count}"
  vpc_security_group_ids        = [ "${aws_security_group.master-dmz.id}" ]
  associate_public_ip_address   = true
  #user_data                     = "${file("../../shared/user-data.txt")}"
  tags {
        Name = "master_node-${count.index + 1}"
       }
  ami                           = "${var.aws_ami}"
  subnet_id                     = "subnet-5e23ba37"
  key_name                      = "cs_ref_arch"
}

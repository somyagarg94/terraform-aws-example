
resource "aws_vpc" "default2" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default2" {
	vpc_id = "${aws_vpc.default2.id}"
}

# NAT instance

resource "aws_security_group" "nat" {
	name = "nat"
	description = "Allow services from the private subnet through NAT"

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.us-east-2b-private.cidr_block}"]
	}
	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		cidr_blocks = ["${aws_subnet.us-east-2c-private.cidr_block}"]
	}

	vpc_id = "${aws_vpc.default2.id}"
}


resource "aws_instance" "nat" {
	ami = "${var.aws_nat_ami}"
	availability_zone = "us-east-2b"
	instance_type = "t2.small"
	key_name = "cs_ref_arch"
	security_groups = ["${aws_security_group.nat.id}"]
	subnet_id = "${aws_subnet.us-east-2b-public.id}"
	associate_public_ip_address = true
}

resource "aws_eip" "nat" {
	instance = "${aws_instance.nat.id}"
	vpc = true
}

# Public subnets

resource "aws_subnet" "us-east-2b-public" {
	vpc_id = "${aws_vpc.default2.id}"

	cidr_block = "10.0.0.0/24"
	availability_zone = "us-east-2b"
}

resource "aws_subnet" "us-east-2c-public" {
	vpc_id = "${aws_vpc.default2.id}"

	cidr_block = "10.0.2.0/24"
	availability_zone = "us-east-2c"
}

# Routing table for public subnets

resource "aws_route_table" "us-east-2-public" {
	vpc_id = "${aws_vpc.default2.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default2.id}"
	}
}

resource "aws_route_table_association" "us-east-2b-public" {
	subnet_id = "${aws_subnet.us-east-2b-public.id}"
	route_table_id = "${aws_route_table.us-east-2-public.id}"
}

resource "aws_route_table_association" "us-east-2c-public" {
	subnet_id = "${aws_subnet.us-east-2c-public.id}"
	route_table_id = "${aws_route_table.us-east-2-public.id}"
}

# Private subsets

resource "aws_subnet" "us-east-2b-private" {
	vpc_id = "${aws_vpc.default2.id}"

	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-2b"
}

resource "aws_subnet" "us-east-2c-private" {
	vpc_id = "${aws_vpc.default2.id}"

	cidr_block = "10.0.3.0/24"
	availability_zone = "us-east-2c"
}

# Routing table for private subnets

resource "aws_route_table" "us-east-2-private" {
	vpc_id = "${aws_vpc.default2.id}"

	route {
		cidr_block = "0.0.0.0/0"
	}
}

resource "aws_route_table_association" "us-east-2b-private" {
	subnet_id = "${aws_subnet.us-east-2b-private.id}"
	route_table_id = "${aws_route_table.us-east-2-private.id}"
}

resource "aws_route_table_association" "us-east-2c-private" {
	subnet_id = "${aws_subnet.us-east-2c-private.id}"
	route_table_id = "${aws_route_table.us-east-2-private.id}"
}
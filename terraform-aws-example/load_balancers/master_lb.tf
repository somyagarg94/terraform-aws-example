resource "aws_elb" "master-lb" {
    name                = "master-lb"
    #availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

    subnets = ["${var.master_subnet}"]

    listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 80
    lb_protocol         = "http"
  }

    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  security_groups       = ["${var.master_security_group}"]

  tags {
      Name              = "master-elb"
  }
#instances              = ["${aws_instance.master_node.id}"]
}

output "master_elb_name" {
    value = "${aws_elb.master-lb.name}"
}
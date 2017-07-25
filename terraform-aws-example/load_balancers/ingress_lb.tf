resource "aws_elb" "ingress-lb" {
    name                = "ingress-lb"
    #availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

    subnets = ["${var.ingress_subnet}"]

    listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 80
    lb_protocol         = "http"
  }
  
 # listener {
 #   instance_port      = 8000
 #   instance_protocol  = "http"
 #  lb_port            = 443
 #   lb_protocol        = "https"
 #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
 # }

    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  security_groups       = ["${var.ingress_security_group}"]

  tags {
      Name              = "ingress-elb"
  }
#instances              = ["${aws_instance.ingress_node.id}"]
}

output "ingress_elb_name" {
    value = "${aws_elb.ingress-lb.name}"
}
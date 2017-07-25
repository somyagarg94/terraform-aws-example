# Create the etcd load balancer 
resource "aws_elb" "etcd-lb" {
    name                = "etcd-lb"
    #availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

    subnets = ["${var.etcd_subnet}"]

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

  security_groups       = ["${var.etcd_security_group}"]

  tags {
      Name              = "etcd-elb"
  }
#instances              = ["${aws_instance.master_node.id}"]
#instances              = ["${var.etcd_instance}"]

}

output "etcd_elb_name" {
    value = "${aws_elb.etcd-lb.name}"
}
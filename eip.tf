resource "aws_eip" "LoadBalancerEIP" {
  instance = "${aws_instance.lb.id}"
}

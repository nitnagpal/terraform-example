output "LoadBalancerIP" {
  value = "${aws_eip.LoadBalancerEIP.public_ip}"
}

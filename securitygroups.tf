resource "aws_security_group" "LoadBalancer" {
  name        = "LoadBalancer"
  tags {
        Name = "LoadBalancer"
  }
  description = "Public facing Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Application" {
  name = "Application"
  tags {
        Name = "Application"
  }
  description = "ONLY tcp CONNECTION INBOUND"
  ingress {
      from_port = 80
      to_port = 80
      protocol = "TCP"
      security_groups = ["${aws_security_group.LoadBalancer.id}"]
  }
  ingress {
      from_port   = "22"
      to_port     = "22"
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

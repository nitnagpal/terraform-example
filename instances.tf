resource "aws_instance" "lb" {
  ami           = "ami-099fe766"
  instance_type = "t2.nano"
  key_name = "MyKP"
  vpc_security_group_ids = ["${aws_security_group.LoadBalancer.id}"]
  associate_public_ip_address = "true"
  tags {
        Name = "lb"
  }

  depends_on = ["aws_instance.phpapp"]

  connection {
      user = "ubuntu"
      type = "ssh"
      private_key = "${file(var.private_key_path)}"
      timeout = "1m"
      agent = true
  }

  provisioner "file" {
    source      = "./nginx_lb.conf"
    destination = "/tmp/nginx_lb.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo cp /tmp/nginx_lb.conf /etc/nginx/sites-available/default",
      "sudo sed -i 's/PRIVATE_IP/${aws_instance.phpapp.private_ip}/' /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx",
    ]
  }

}

resource "aws_instance" "phpapp" {
  ami           = "ami-099fe766"
  instance_type = "t2.nano"
  key_name = "MyKP"
  vpc_security_group_ids = ["${aws_security_group.Application.id}"]
  associate_public_ip_address = "true"
  tags {
        Name = "phpapp"
  }

  connection {
      user = "ubuntu"
      type = "ssh"
      private_key = "${file(var.private_key_path)}"
      timeout = "1m"
      agent = true
  }

  provisioner "file" {
    source      = "./nginx_php.conf"
    destination = "/tmp/nginx_php.conf"
  }

  provisioner "file" {
    source      = "./info.php"
    destination = "/tmp/info.php"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx git mcrypt php-cli php-curl php-fpm php-mysql php-sqlite3 sqlite3",
      "sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini",
      "sudo systemctl restart php7.0-fpm",
      "sudo cp /tmp/nginx_php.conf /etc/nginx/sites-available/default",
      "sudo cp /tmp/info.php /var/www/html/info.php",
      "sudo systemctl restart nginx",
    ]
  }

}

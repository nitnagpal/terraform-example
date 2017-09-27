 resource "aws_key_pair" "MyKP" {
   key_name   = "MyKP"
   public_key = "${file(var.public_key_path)}"
 }

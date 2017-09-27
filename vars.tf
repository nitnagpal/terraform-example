variable "public_key_path" {
  description = "Path to the SSH Public Key"
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the SSH Private Key"
  default = "~/.ssh/id_rsa.decr" /*Passwordless or Descrypted Private Key*/
}

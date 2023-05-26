# ============ #
# SSH KEY PAIR #
# ============ #
resource "aws_key_pair" "ec2_key" {
  key_name   = "ssh_key"
  public_key = tls_private_key.rsa.public_key_openssh

  tags = {
    "Product" = "key-pair"
  }
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

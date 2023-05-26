################################################################################
#                     AWS MARKETPLACE CASSANDRA AMI                            #
################################################################################
data "aws_ami" "cassandra_ami" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "name"
    values = ["Apache Cassandra on ubuntu 22.04 --5789e359-f513-4969-980c-38a720041130*"]
  }
}

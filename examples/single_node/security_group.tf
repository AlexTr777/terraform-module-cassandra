# ====================== #
# SG | cassandra Cluster #
# ====================== #

resource "aws_security_group" "cassandra_cluster" {
  name        = "cassandra-cluster"
  description = "SG for cassandra cluster ASG"

  vpc_id = "vpc-0d24953f4e5a823c2"

  tags = {
    "Name" = "cassandra-cluster"
  }
}

# =================================== #
# cassandra Cluster SG | Egress rules #
# =================================== #

resource "aws_security_group_rule" "cassandra_cluster_egress" {
  description       = "All-all"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "egress"
  protocol  = "-1"
  from_port = 0
  to_port   = 0

  cidr_blocks = ["0.0.0.0/0"] 
}

# =================================================== #
# cassandra Cluster SG | cassandra cluster dependency #
# =================================================== #

resource "aws_security_group_rule" "cassandra_cluster_ingress_self_internode_communication_tcp" {
  description       = "(Self) Allow TCP inbound. The port used by servers for TLS and NO-TLS internode communication. (cassandra cluster dependency)"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 7000
  to_port   = 7001

  self = true
}


resource "aws_security_group_rule" "cassandra_cluster_ingress_self_allow_http_api" {
  description       = "(Self) Allow HTTP API inbound. The port used by clients to talk to the HTTP API. (cassandra cluster dependency)"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 9042
  to_port   = 9042

  self = true
}

resource "aws_security_group_rule" "cassandra_cluster_ingress_self_allow_https_api" {
  description       = "(Self) Allow HTTPS API inbound. The port used by clients to talk to the HTTPS API. (cassandra cluster dependency)"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 9142
  to_port   = 9142

  self = true
}

resource "aws_security_group_rule" "cassandra_cluster_ingress_self_allow_thrift_api" {
  description       = "(Self) Allow Thrift client API inbound. The port used by clients to talk to the Thrift API. (cassandra cluster dependency)"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "ingress"
  protocol  = "tcp"
  from_port = 9160
  to_port   = 9160

  self = true
}

resource "aws_security_group_rule" "cassandra_cluster_ingress_external_networks" {
  description       = "Access to cassandra nodes from external networks"
  security_group_id = aws_security_group.cassandra_cluster.id

  type      = "ingress"
  protocol  = "-1"
  from_port = 0
  to_port   = 0

  cidr_blocks = ["0.0.0.0/0"]
}

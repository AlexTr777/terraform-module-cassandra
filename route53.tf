# ======== #
# Route 53 #
# ======== #
resource "aws_route53_record" "cluster_route53" {
  count = var.cluster_dns_endpoint_enabled ? 1 : 0

  name = var.cassandra_cluster.cluster_name

  type    = "A"
  ttl     = "3600"
  zone_id = var.route53_dns_zone_id

  records = local.cluster_nodes_ips
}

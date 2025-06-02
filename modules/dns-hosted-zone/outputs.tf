output "zone_id" {
  description = "Zone ID of the Route53 zone."
  value = length(aws_route53_zone.spoke_dns) > 0 ? aws_route53_zone.spoke_dns["spoke"].zone_id : aws_route53_zone.dns["dns"].zone_id
}

output "zone_arn" {
  description = "ARN of the Route53 zone."
  value = length(aws_route53_zone.spoke_dns) > 0 ? aws_route53_zone.spoke_dns["spoke"].arn : aws_route53_zone.dns["dns"].arn
}

output "name_servers" {
  description = "Name servers of the Route53 zone."
  value = length(aws_route53_zone.spoke_dns) > 0 ? aws_route53_zone.spoke_dns["spoke"].name_servers : aws_route53_zone.dns["dns"].name_servers
}

output "primary_name_server" {
  description = "The Route 53 name server that created the SOA record."
  value = length(aws_route53_zone.spoke_dns) > 0 ? aws_route53_zone.spoke_dns["spoke"].primary_name_server : aws_route53_zone.dns["dns"].primary_name_server
}

output "zone_name" {
  description = "Name of the Route53 zone."
  value = length(aws_route53_zone.spoke_dns) > 0 ? aws_route53_zone.spoke_dns["spoke"].name : aws_route53_zone.dns["dns"].name
}
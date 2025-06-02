output id {
  description = "List of endpoint IDs"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.id
}

output arn {
  description = "List of endpoint ARNs"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.arn
}

output name {
  description = "List of endpoint Names"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.name
}

output security_group_ids {
  description = "Security Group IDs mapped to Resolver Endpoint"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.security_group_ids
}

output "ip_addresses" {
  description = "Resolver Endpoint IP Addresses"
  value       = aws_route53_resolver_endpoint.resolver_endpoint.ip_address
}
output "id" {
  description = "List of rule IDs"
  value       =  [for i in aws_route53_resolver_rule.resolver_rule : i.id]
}


output "arn" {
  description = "List of rule Arns"
  value       =  [for i in aws_route53_resolver_rule.resolver_rule : i.arn]
}

output "name" {
  description = "List of rule Names"
  value       =  [for i in aws_route53_resolver_rule.resolver_rule : i.name]
}
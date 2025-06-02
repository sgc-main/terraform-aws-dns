resource "aws_route53_resolver_rule" "resolver_rule" {
  for_each             = {for i in var.forwarding_rules:i.name=>i}
  domain_name          = each.value.domain_name
  name                 = each.value.name
  rule_type            = each.value.rule_type
  resolver_endpoint_id = var.outbound_endpoint_id

  dynamic "target_ip" {
    for_each = each.value.ips
    content {
      ip = target_ip.value
    }
  }
  
  tags = var.tags
}

resource "aws_ram_resource_share" "dns" {
  for_each                  = length(var.ram_principals_list) == 0 ? {} : tomap({"dns" = 1})
  name                      = var.ram_resource_share_name
  allow_external_principals = false

  tags = merge(var.tags, tomap({"Name" = "${var.ram_resource_share_name}"}))
}

resource "aws_ram_resource_association" "dns" {
  for_each           = length(var.ram_principals_list) == 0 ? {} : {for i in var.forwarding_rules:i.name=>i}
  resource_arn       = aws_route53_resolver_rule.resolver_rule[each.key].arn
  resource_share_arn = aws_ram_resource_share.dns["dns"].arn
}

resource "aws_ram_principal_association" "acctname" {
  for_each           = length(var.ram_principals_list) == 0 ? {} : { for idx, principal in var.ram_principals_list: principal => idx }
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.dns["dns"].arn
}

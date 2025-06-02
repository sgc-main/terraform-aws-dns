locals {
  create_spoke_dns = var.zone_type == "private" && var.associate && length(var.hub_vpcs) > 0
  create_dns       = !local.create_spoke_dns
}

resource "aws_route53_zone" "spoke_dns" {
  for_each = local.create_spoke_dns ? { "spoke" = true } : {}

  name          = var.domain_name
  comment       = var.comment
  force_destroy = var.force_destroy

  dynamic "vpc" {
    for_each = var.vpcs
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone" "dns" {
  for_each = local.create_dns ? { "dns" = true } : {}

  name              = var.domain_name
  comment           = var.comment
  force_destroy     = var.force_destroy
  delegation_set_id = var.zone_type == "public" ? var.delegation_set_id : null

  dynamic "vpc" {
    for_each = var.zone_type == "private" ? var.vpcs : {}
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags = var.tags

}

locals {
  cross_account_associations = local.create_spoke_dns ? [
    for vpc_name, vpc in var.hub_vpcs : {
      key        = "${vpc.vpc_id}-${lookup(vpc, "vpc_region", "default")}"
      vpc_id     = vpc.vpc_id
      vpc_region = lookup(vpc, "vpc_region", null)
    }
  ] : []
}

resource "aws_route53_vpc_association_authorization" "spoke" {
  for_each   = { for a in local.cross_account_associations : a.key => a }

  vpc_id     = each.value.vpc_id
  vpc_region = each.value.vpc_region
  zone_id    = aws_route53_zone.spoke_dns["spoke"].zone_id
  depends_on = [aws_route53_zone.spoke_dns]
}

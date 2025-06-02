locals {
  name               = "${var.prefix}-ept-${lower(var.direction)}-${var.env}"
}

resource "aws_security_group" "resolver_endpoint" {
  name_prefix = "${local.name}-"
  description = "SG for ${local.name}"
  vpc_id      = var.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = toset(["tcp", "udp"])
    content {
      description = "Allow DNS"
      protocol    = ingress.value
      from_port   = 53
      to_port     = 53
      cidr_blocks = var.security_group_ingress_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = toset(["tcp", "udp"])
    content {
      description = "Allow DNS"
      protocol    = egress.value
      from_port   = 53
      to_port     = 53
      cidr_blocks = var.security_group_egress_cidr_blocks
    }
  }

  tags = merge(var.tags, { Name = local.name })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_resolver_endpoint" "resolver_endpoint" {
  name      = local.name
  direction = upper(var.direction)

  security_group_ids = [aws_security_group.resolver_endpoint.id]

 dynamic "ip_address" {
    for_each = var.subnet_ids
    content {
      subnet_id = ip_address.value
    }
  }

  tags = var.tags
}

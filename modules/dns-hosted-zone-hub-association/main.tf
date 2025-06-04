terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

locals {
  association_list_of_maps = flatten([
    for vpc_name, vpc in var.hub_vpcs : [
      for zone_name, phz_id in var.phz : {
        vpc_name   = vpc_name
        vpc_region = vpc.vpc_region
        vpc_id     = vpc.vpc_id
        phz_name   = zone_name
        phz_id     = phz_id
      }
    ]
  ])
}

resource "aws_route53_zone_association" "hz_hub_association" {
  for_each   = { for p in local.association_list_of_maps : "${p.vpc_id}-${p.vpc_region}-${p.phz_name}" => p }

  vpc_id     = each.value.vpc_id
  vpc_region = each.value.vpc_region
  zone_id    = each.value.phz_id
}

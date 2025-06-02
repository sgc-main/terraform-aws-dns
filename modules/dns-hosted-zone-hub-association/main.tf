
locals {
    association_list_of_maps = flatten ([
    for key, value in var.hub_vpcs : [
      for phz in var.phz_ids : {
        vpc_name   = key
        vpc_region = value.vpc_region
        vpc_id     = value.vpc_id
        phz_id     = phz
      }
    ]
  ])
}

resource "aws_route53_zone_association" "hz_hub_association" {
  for_each   = { for p in local.association_list_of_maps : "${p.vpc_id}-${p.vpc_region}-${p.phz_id}" => p }

  vpc_id     = each.value.vpc_id
  vpc_region = each.value.vpc_region
  zone_id    = each.value.phz_id
}

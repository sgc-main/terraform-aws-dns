# Simple Private Hosted Zone

module "simple_prv_hz" {
  source = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone"

  domain_name   = "simple-prv-hz.com"
  comment       = "Example domain"
  force_destroy = false
  zone_type     = "private"
  vpc = {
    "namedvpc1" = {
      vpc_id     = "vpc-12345678"
      vpc_region = "us-west-2"
    }
  }
  tags = { Environment = "Production" }

}

# Simple Public Hosted Zone

module "simple_pub_hz" {
  source = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone"

  domain_name       = "simple-pub-hz.com"
  comment           = "Example domain"
  force_destroy     = false
  zone_type         = "public"
  tags = { Environment = "Production" }

}

# Mixed Hosted Zone creation

variable mixed_hz {
  default = {
    "simple-prv-hz.com" = {
      domain_name   = "simple-prv-hz.com"
      comment       = "Example domain"
      force_destroy = false
      zone_type     = "private"
      vpcs = {
        "namedvpc1" = {
          vpc_id     = "vpc-12345678"
          vpc_region = "us-west-2"
        }
      }
      tags = { Environment = "Production" }
    }
    "simple-pub-hz.com" = {
      domain_name       = "simple-pub-hz.com"
      comment           = "Example domain"
      force_destroy     = false
      zone_type         = "public"
      tags              = { Environment = "Production" }
    }
  }
}

module "mixed_hz" {
  source = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone"
  for_each = var.mixed_hz

  domain_name       = each.value.domain_name
  comment           = each.value.comment
  force_destroy     = each.value.force_destroy
  delegation_set_id = lookup(each.value, "delegation_set_id", null)
  zone_type         = each.value.zone_type
  vpcs              = lookup(each.value, "vpcs", {})
  tags              = lookup(each.value, "tags", {})
}

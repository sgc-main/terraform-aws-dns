# Public Hosted Zone 1 with Delegation Set

resource "aws_route53_delegation_set" "dns1" {
  reference_name = "DNS"
}

resource "aws_route53_zone" "dns" {
  name              = "simple-pub-hz1.com"
  delegation_set_id = aws_route53_delegation_set.dns1.id
}

# Public Hosted Zone 2 with Delegation Set

resource "aws_route53_delegation_set" "dns2" {
  reference_name = "DNS"
}

module "simple_pub_hz" {
  source = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone"

  domain_name       = "simple-pub-hz2.com"
  zone_type         = "public"
  comment           = "Example domain"
  delegation_set_id = aws_route53_delegation_set.dns2.id
  tags              = { Environment = "Production" }
}


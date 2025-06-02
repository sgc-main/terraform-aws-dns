
provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "hub_account"
  profile = "hub_account"
}

variable hub_vpcs {
  description = "Map of VPCs to associate with the Private Hosted Zones, where the key is the VPC name"
  type = map(object({
      vpc_id     = string
      vpc_region = optional(string)
  }))
  default = {
    "hubvpc1"  = {
      vpc_id     = "vpc-87654321"
      vpc_region = "us-east-1"
    }
  }
}

# Private Hosted Zone with Association Authorization

module "prv_hz_with_association_authorization" {
  source         = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone"

  domain_name    = "simple-prv-hz.com"
  comment        = "Example domain"
  force_destroy  = false
  zone_type      = "private"
  hub_vpcs       = var.hub_vpcs
  associate      = true
  vpc = {
    "namedvpc1"  = {
      vpc_id     = "vpc-12345678"
      vpc_region = "us-east-1"
    }
  }
  tags           = { Environment = "Production" }
  providers      = { aws = aws }
}

# Private Hosted Zone Authorization

module "prv_hz_with_authorization" {
  source         = "github.com/sgc-main/terraform-aws-dns/modules/dns-hosted-zone-hub-association"
  
  phz_ids        = [ module.prv_hz_with_association_authorization.zone_id ]
  hub_vpcs       = var.hub_vpcs
  tags           = { Environment = "Production" }
  providers      = { aws = aws.hub_account }

}
# AWS DNS Infrastructure Helper Modules

Terraform modules that ease deployment of R53 infrastructure components.

Module Components:
* [dns-hosted-zone](https://github.com/sgc-main/terraform-aws-dns/tree/main/modules/dns-hosted-zone) - Standardizes the creation of Private and Public Route 53 Hosted Zones
* [dns-hosted-zone-hub-association](https://github.com/sgc-main/terraform-aws-dns/tree/main/modules/dns-hosted-zone-hub-association) - Standardizes the creation of Private Hosted Zone Associations
* [dns-resolver-endpoint](https://github.com/sgc-main/terraform-aws-dns/tree/main/modules/dns-resolver-endpoint) - Standardizes the creation of Inbound and Outbound Route 53 Resolver Endpoints
* [dns-resolver-rule](https://github.com/sgc-main/terraform-aws-dns/tree/main/modules/dns-resolver-rule) - Standardizes the dynamic creation of forwarding rules

Full documentation is available at the submodule level, for each case.

<!-- BEGIN_TF_DOCS -->
## Examples

### DNS Hosted Zones 

```hcl
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
```  

```hcl
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

```  

```hcl

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
```  

### DNS Resolver Endpoint

```hcl
# Inbound and Outbound Resolver Endpoints

variable vpc_presets {
  type = map
  default = {
    VpcName     = "vpc-1"
    SubnetNames = "subnet-1,subnet-2"
  }
}

variable tags {
  type = map
  default = { Environment = "Production"  }
}

variable prefix {
  type = string
  default = "dns"
}

variable env {
  type = string
  default = "prd"
}

module "vpc_presets" {
  source   = "github.com/sgc-main/terraform-aws-vpc-presets"
  vpc_name = lookup(var.vpc_presets, "VpcName")
  subnets  = lookup(var.vpc_presets, "SubnetNames")
}

module "inbound-endpoint" {
  source      = "github.com/sgc-main/terraform-aws-dns/modules/dns-resolver-endpoint"
  direction   = "inbound"
  tags        = var.tags
  prefix      = var.prefix
  env         = var.env
  vpc_id      = module.vpc_presets.vpc_id
  subnet_ids  = module.vpc_presets.subnet_ids
}

module "outbound-endpoint" {
  source      = "github.com/sgc-main/terraform-aws-dns/modules/dns-resolver-endpoint"
  direction   = "outbound"
  tags        = var.tags
  prefix      = var.prefix
  env         = var.env
  vpc_id      = module.vpc_presets.vpc_id
  subnet_ids  = module.vpc_presets.subnet_ids
}
```  

### DNS Resolver Rule

```hcl
# Resolver Rules Shared to the Organization

variable vpc_presets {
  type = map
  default = {
    VpcName     = "vpc-1"
    SubnetNames = "subnet-1,subnet-2"
  }
}

variable tags {
  type = map
  default = { Environment = "Production" }
}

variable prefix {
  type = string
  default = "dns"
}

variable env {
  type = string
  default = "prd"
}

variable ram_principals {
  type = list(string)
  default = [ "arn:aws:organizations::123456789123:organization/o-ss12a3bcde" ]
}

variable forwarding_rules {
  type = list
  default = [
    {
       domain_name = "test1.com"
       name        = "test1_com"
       rule_type   = "FORWARD"
       ips         = ["10.1.1.5", "10.1.1.6"]
    },
    {
       domain_name = "test2.com"
       name        = "test2_com"
       rule_type   = "FORWARD"
       ips         = ["10.1.2.5", "10.1.2.6"]
    }
  ]
}

module "vpc_presets" {
  source   = "github.com/sgc-main/terraform-aws-vpc-presets"
  vpc_name = lookup(var.vpc_presets, "VpcName")
  subnets  = lookup(var.vpc_presets, "SubnetNames")
}

module "outbound-endpoint" {
  source      = "github.com/sgc-main/terraform-aws-dns/modules/dns-resolver-endpoint"
  direction   = "outbound"
  tags        = var.tags
  prefix      = var.prefix
  env         = var.env
  vpc_id      = module.vpc_presets.vpc_id
  subnet_ids  = module.vpc_presets.subnet_ids
}

module "forwarding-rules" {
  source               = "github.com/sgc-main/terraform-aws-dns/modules/dns-resolver-rule"
  tags                 = var.tags
  forwarding_rules     = var.forwarding_rules
  outbound_endpoint_id = module.outbound-endpoint.resolver_endpoint_id
  enable_ram_share     = true
  ram_principals       = var.ram_principals
}

```  
<!-- END_TF_DOCS -->
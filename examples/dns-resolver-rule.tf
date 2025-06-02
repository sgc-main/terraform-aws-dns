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


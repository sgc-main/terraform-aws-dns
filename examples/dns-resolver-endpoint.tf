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

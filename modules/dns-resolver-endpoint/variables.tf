variable prefix {
  description = "Prefix"
  type        = string
  default     = "dns"
}

variable env {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable vpc_id {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable subnet_ids {
  description = "A list of subnet IDs"
  type = list
  default = []
}

variable tags {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}

variable direction {
  description = "The direction of the resolver endpoint"
  type        = string
  default     = "outbound"
}

variable security_group_ingress_cidr_blocks {
  description = "A list of CIDR blocks for security group ingress rules"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable security_group_egress_cidr_blocks {
  description = "A list of CIDR blocks for security group egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


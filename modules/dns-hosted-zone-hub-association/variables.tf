variable phz_ids {
  type        = list(string)
  description = "List of delegated Private Hosted Zone IDs to associate with the VPCs in the hub account"
  default     = []
}

variable "hub_vpcs" {
  description = "Map of VPCs to associate with the Private Hosted Zones, where the key is the VPC name"
  type = map(object({
      vpc_id     = string
      vpc_region = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(string)
  default     = {}
}
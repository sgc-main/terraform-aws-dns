
variable forwarding_rules {
    type = list
}
variable outbound_endpoint_id {}
variable tags {
  type    = map
  default = {}
}

variable ram_resource_share_name {
  type    = string
  default = "dns_forwarding_share_0"
}

variable ram_principals_list {
  type    = list
  default = []
}
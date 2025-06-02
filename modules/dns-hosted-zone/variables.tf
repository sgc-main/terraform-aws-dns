variable "domain_name" {
  description = "The DNS name of the hosted zone."
  type        = string
}

variable "comment" {
  description = "A comment for the hosted zone."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Whether to destroy all records in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "zone_type" {
  description = "Type of the hosted zone: public or private."
  type        = string
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set to assign to the public zone."
  type        = string
  default     = null
}

variable "vpcs" {
  description = "Map of VPCs (local) to associate for private zones. Each value has vpc_id and vpc_region."
  type = map(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the hosted zone."
  type        = map(string)
  default     = {}
}

variable "hub_vpcs" {
  description = "Map of hub VPCs for cross-account delegation/association."
  type = map(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = {}
}

variable "associate" {
  description = "If true, and hub_vpcs is non-empty, enable association/authorization for delegation from the management/root account."
  type        = bool
  default     = false
}
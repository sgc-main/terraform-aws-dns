# AWS Route53 Hosted Zone Terraform sub-module

This sub-module standardizes the acceptance of Private Hosted Zone cross-account associations in a hub account within a hub-and-spoke architecture.  
In this setup, association authorizations are created in multiple spoke accounts, but there is a single authorization acceptance hub account.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone_association.hz_hub_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_hub_vpcs"></a> [hub\_vpcs](#input\_hub\_vpcs) | Map of VPCs to associate with the Private Hosted Zones, where the key is the VPC name | <pre>map(object({<br/>      vpc_id     = string<br/>      vpc_region = optional(string)<br/>  }))</pre> | `{}` |
| <a name="input_phz_ids"></a> [phz\_ids](#input\_phz\_ids) | List of delegated Private Hosted Zone IDs to associate with the VPCs in the hub account | `list(string)` | `[]` |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags added to all zones. Will take precedence over tags from the 'zones' variable | `map(string)` | `{}` |

<!-- END_TF_DOCS -->

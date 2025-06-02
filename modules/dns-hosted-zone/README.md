# AWS Route53 Hosted Zone Terraform sub-module

Standardizes the creation of Private and Public Route 53 Hosted Zones

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_vpc_association_authorization.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization) | resource |
| [aws_route53_zone.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.spoke_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_associate"></a> [associate](#input\_associate) | If true, and hub\_vpcs is non-empty, enable association/authorization for delegation from the management/root account. | `bool` | `false` |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. | `string` | `""` |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set to assign to the public zone. | `string` | `null` |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The DNS name of the hosted zone. | `string` | n/a |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records in the zone when destroying the zone. | `bool` | `false` |
| <a name="input_hub_vpcs"></a> [hub\_vpcs](#input\_hub\_vpcs) | Map of hub VPCs for cross-account delegation/association. | <pre>map(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `{}` |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the hosted zone. | `map(string)` | `{}` |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | Map of VPCs (local) to associate for private zones. Each value has vpc\_id and vpc\_region. | <pre>map(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `{}` |
| <a name="input_zone_type"></a> [zone\_type](#input\_zone\_type) | Type of the hosted zone: public or private. | `string` | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Name servers of the Route53 zone. |
| <a name="output_primary_name_server"></a> [primary\_name\_server](#output\_primary\_name\_server) | The Route 53 name server that created the SOA record. |
| <a name="output_zone_arn"></a> [zone\_arn](#output\_zone\_arn) | ARN of the Route53 zone. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Zone ID of the Route53 zone. |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Name of the Route53 zone. |
<!-- END_TF_DOCS -->

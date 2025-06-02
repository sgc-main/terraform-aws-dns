# AWS Route53 Forwarding Rules Deployment Terraform sub-module

Standardizes the dynamic creation of forwarding rules and sharing to AWS Organizaitons.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.acctname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53_resolver_rule.resolver_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_forwarding_rules"></a> [forwarding\_rules](#input\_forwarding\_rules) | n/a | `list` | n/a |
| <a name="input_outbound_endpoint_id"></a> [outbound\_endpoint\_id](#input\_outbound\_endpoint\_id) | n/a | `any` | n/a |
| <a name="input_ram_principals_list"></a> [ram\_principals\_list](#input\_ram\_principals\_list) | n/a | `list` | `[]` |
| <a name="input_ram_resource_share_name"></a> [ram\_resource\_share\_name](#input\_ram\_resource\_share\_name) | n/a | `string` | `"dns_forwarding_share_0"` |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | List of rule Arns |
| <a name="output_id"></a> [id](#output\_id) | List of rule IDs |
| <a name="output_name"></a> [name](#output\_name) | List of rule Names |
<!-- END_TF_DOCS -->
# AWS Route53 Forwarding Rules Deployment Terraform sub-module

Standardizes the creation of Inbound and Outbound Route 53 Resolver Endpoints.
- The Default Security Group and Endpoint names are standardized based on the following structure `prefix`-`endpoint direction (inbound / outbound)`-`environment`.
- If a list of `security_group_ids` are specified, the default security group is no longer created and the specified security groups are used.
- Endpoint IP addressess are assigned dynamically from the IP CIDR blocks associated with the subnets used.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_resolver_endpoint.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_security_group.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_direction"></a> [direction](#input\_direction) | The direction of the resolver endpoint | `string` | `"outbound"` |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | `"dev"` |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix | `string` | `"dns"` |
| <a name="input_security_group_egress_cidr_blocks"></a> [security\_group\_egress\_cidr\_blocks](#input\_security\_group\_egress\_cidr\_blocks) | A list of CIDR blocks for security group egress rules | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> |
| <a name="input_security_group_ingress_cidr_blocks"></a> [security\_group\_ingress\_cidr\_blocks](#input\_security\_group\_ingress\_cidr\_blocks) | A list of CIDR blocks for security group ingress rules | `list(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs | `list` | `[]` |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags | `map(string)` | `{}` |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | List of endpoint ARNs |
| <a name="output_id"></a> [id](#output\_id) | List of endpoint IDs |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | Resolver Endpoint IP Addresses |
| <a name="output_name"></a> [name](#output\_name) | List of endpoint Names |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Security Group IDs mapped to Resolver Endpoint |
<!-- END_TF_DOCS -->
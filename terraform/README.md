## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13.6 |
| aws | = 3.23.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_log\_bucket\_name | n/a | `any` | n/a | yes |
| account\_id | n/a | `any` | n/a | yes |
| availability\_zones | The az that the resources will be launched | `list` | n/a | yes |
| container\_name | n/a | `any` | n/a | yes |
| container\_port | n/a | `any` | n/a | yes |
| default\_tags | n/a | `any` | n/a | yes |
| dns\_zone\_id | n/a | `any` | n/a | yes |
| ecs\_image\_id | n/a | `any` | n/a | yes |
| ecs\_image\_version | n/a | `any` | n/a | yes |
| elb\_account\_id | n/a | `any` | n/a | yes |
| environment | The environment | `any` | n/a | yes |
| key\_pair\_name | n/a | `any` | n/a | yes |
| private\_subnets\_cidr | n/a | `list` | n/a | yes |
| project\_env | n/a | `any` | n/a | yes |
| public\_subnets\_cidr | n/a | `list` | n/a | yes |
| region | Region that the instances will be created | `any` | n/a | yes |
| route53\_record\_name | n/a | `any` | n/a | yes |
| service\_name | n/a | `any` | n/a | yes |
| vpc\_cidr | n/a | `any` | n/a | yes |
| alias\_records | n/a | `list` | `[]` | no |
| egress\_instance\_cidr\_rules | n/a | `list` | `[]` | no |
| egress\_instance\_sg\_rules | n/a | `list` | `[]` | no |
| egress\_lb\_sg\_rules | n/a | `list` | `[]` | no |
| ingress\_instance\_sg\_rules | n/a | `list` | `[]` | no |
| ingress\_lb\_cidr\_rules | n/a | `list` | `[]` | no |
| ingress\_lb\_sg\_rules | n/a | `list` | `[]` | no |
| key\_public\_material | n/a | `string` | `""` | no |
| listeners | n/a | `list` | `[]` | no |
| target\_group\_health\_checks | n/a | `list` | `[]` | no |
| target\_groups | n/a | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_endpoint | n/a |

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13.6 |
| aws | = 3.23.0 |

## Providers

| Name | Version |
|------|---------|
| aws | = 3.23.0 |
| local | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | n/a | `any` | n/a | yes |
| project\_env | n/a | `any` | n/a | yes |
| region | n/a | `any` | n/a | yes |
| service\_name | n/a | `any` | n/a | yes |
| name | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_log\_bucket\_name | n/a |
| availability\_zones | n/a |
| dynamodb\_table\_name | n/a |
| state\_bucket\_name | n/a |

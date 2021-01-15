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
| null | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| applications | List of application prefixes to add in access log s3 bucket policy, must be a comma separated string. For example | `string` | n/a | yes |
| environment | Name of your environment | `string` | n/a | yes |
| project\_env | system environment, for example dev, test or uat | `string` | n/a | yes |
| region | Region in which you want to create infrastructure and deploy application | `string` | n/a | yes |
| route53\_domain\_name | Name of the Route53 domain in which application will be hosted | `string` | n/a | yes |
| route53\_record\_name | DNS name for application, must be a subdomain of route53\_domain\_name | `string` | n/a | yes |
| service\_name | Name of your service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| access\_log\_bucket\_name | n/a |
| availability\_zones | n/a |
| dynamodb\_table\_name | n/a |
| state\_bucket\_name | n/a |

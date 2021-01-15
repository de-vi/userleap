## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.13.6 |
| aws | = 3.23.0 |

## Providers

| Name | Version |
|------|---------|
| aws | = 3.23.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_name | Container name for task definiton | `string` | n/a | yes |
| container\_port | Container port where application is running | `string` | n/a | yes |
| ecs\_image\_id | ECR image name | `string` | n/a | yes |
| ecs\_image\_version | ECR image version | `string` | n/a | yes |
| environment | Name of your environment | `string` | n/a | yes |
| key\_pair\_name | Name of the keypair available in the region where the application is deployed, mutually exclusive with key\_public\_material | `string` | n/a | yes |
| private\_subnets\_cidr | CIDR for private subnets | `list` | n/a | yes |
| project\_env | system environment, for example dev, test or uat | `string` | n/a | yes |
| public\_subnets\_cidr | CIDR for public subnets | `list` | n/a | yes |
| region | Region in which you want to create infrastructure and deploy application | `string` | n/a | yes |
| route53\_domain\_name | Name of the Route53 domain in which application will be hosted | `string` | n/a | yes |
| route53\_record\_name | DNS name for application, must be a subdomain of route53\_domain\_name | `string` | n/a | yes |
| service\_name | Name of your service | `string` | n/a | yes |
| vpc\_cidr | CIDR for VPC | `string` | n/a | yes |
| egress\_instance\_cidr\_rules | List of outbound security group rules for instance with source security CIDR blocks | `list(map(string))` | `[]` | no |
| egress\_instance\_sg\_rules | List of outbound security group rules for instance with source security group ids | `list(map(string))` | `[]` | no |
| egress\_lb\_sg\_rules | List of outbound security group rules for ALB with source security group ids | `list(map(string))` | `[]` | no |
| ingress\_instance\_sg\_rules | List of inbound security group rules for instance with source security group ids | `list(map(string))` | `[]` | no |
| ingress\_lb\_cidr\_rules | List of inbound security group rules for ALB with source security CID blocks | `list(map(string))` | `[]` | no |
| ingress\_lb\_sg\_rules | List of inbound security group rules for ALB with source security group ids | `list(map(string))` | `[]` | no |
| key\_public\_material | Publi key material using which a new keypair can be created, mutually exclusive with key\_pair\_name | `string` | `""` | no |
| listeners | List of listeners for ALB | `list(map(string))` | `[]` | no |
| target\_group\_health\_checks | List of health checks for each target group, must contain same number of elements as target\_groups | `list(map(string))` | `[]` | no |
| target\_groups | List of target groups to create | `list(map(string))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_endpoint | n/a |

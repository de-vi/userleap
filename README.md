# Dockerized Flask App hosted on ECS(with autoscaling group and dynamic port mapping)



## Repository Structure:
### app
Has Dockerfile and helper script required to create Docker image
```
cd app
# Replace xxxxxxxxxxxx.dkr.ecr.us-west-1.amazonaws.com with ECR registry URL
docker build . -t xxxxxxxxxxxx.dkr.ecr.us-west-1.amazonaws.com/userleap
aws ecr get-login-password --region region | docker login --username AWS --password-stdin xxxxxxxxxxxx.dkr.ecr.us-west-1.amazonaws.com
docker push xxxxxxxxxxxx.dkr.ecr.us-west-1.amazonaws.com/userleap
```

### prerequisites
Has terraform code to setup project

## Minimum Required Variables for terraform execution

- *route53_domain_name* - Route53 domain name in which you want to create app dns record
- *route53_record_name* - Route53(DNS) record name for your application

---
**NOTE**

- The route53_domain_name must be a public zone
- route53_record_name must be a subdomain of route53_domain_name
    - For example, if route53_domain_name is example.com then route53_record_name can be dev.example.com or test.example.com
- These are used to issue an ACM certificate 

---

```
cd prerequisites
# replace region_name with region of your choice, for example - us-east-1 or us-west-1
AWS_PROFILE=<profile> terraform init -var="region=<region_name>"
AWS_PROFILE=<profile> terraform plan -var="region=<region_name>"
AWS_PROFILE=<profile> terraform apply -var="region=<region_name>"
```

![Pre-requisites](img/prereq.gif)

#### Creates:
- S3 bucket to store state
- Dynamodb to create lock table
- S3 bucket to store load balancer access logs 
- Backend file for application infra build
- Certificate for application endpoint


### terraform
Has code to build infrastructure and deploy application

## Minimum required variables

- *ecs_image_id*      - "xxxxxxxxxxxx.dkr.ecr.<region_name>.amazonaws.com/<ecr_repo_name>"
- *ecs_image_version* - "latest"

---
**NOTE**

- Replace xxxxxxxxxx with account id and region_name with region in which the docker image is stored
- Use appropriate version number/format for ecs_image_version if you have custom image names

---

```
cd terraform
# replace region_name with region of your choice, for example - us-east-1 or us-west-1
AWS_PROFILE=<profile> terraform init -var="region=<region_name>"
AWS_PROFILE=<profile> terraform plan -var="region=<region_name>"
AWS_PROFILE=<profile> terraform apply -var="region=<region_name>"
```

![Deploy](img/deploy.gif)

#### Creates: 
- VPC with
  - Private and public subnets
  - Gateways(internet, NAT and egress only gateway)
  - Default route tables
  - Default security group
  - Default NACL

- Autoscaling
  - Launch Configurations
  - Instance Profile
  - Security Group
  - Autoscaling group

- Load Balancer
  - Application load balancer
  - Security Group
  - Target group
  - Access logs enabled
  - HTTPS listener

- DNS:
  - An A record for application pointing to load balancer's DNS name

- ECS:
  - Cluster
  - Task definition
  - ECS service

### terraform/test
Has terratest code to validate the deployment

```
cd terraform/test
AWS_PROFILE=<profile> go test
```

#### Performs: 
- Terraform init and apply
- Take application url from terraform response
- Perform http get on the / endpoint and validates response code & content
- Terraform destroy

---
*NOTE*

This must be run after the prerequisites execution

---

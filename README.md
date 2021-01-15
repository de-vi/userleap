# Dockerized Flask App hosted on ECS(with autoscaling group)

## Repository Structure:
### app
Has Dockerfile and helper script required to create Docker image
```
cd app
docker build . -t <tag_for_image>
docker login
docker tag as per ECR instructions
docker push with aws ecr format
```

### prerequisites
Has terraform code to setup project
```
cd prerequisites
AWS_PROFILE=<profile> terraform init
AWS_PROFILE=<profile> terraform plan
AWS_PROFILE=<profile> terraform apply
```

![Pre-requisites](img/prereq.gif)

#### Creates:
- S3 bucket to store state
- Dynamodb to create lock table
- S3 bucket to store load balancer access logs 
- Backend file for application infra build

### terraform
Has code to build infrastructure and deploy application
```
cd terraform
AWS_PROFILE=<profile> terraform init
AWS_PROFILE=<profile> terraform plan
AWS_PROFILE=<profile> terraform apply
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

- Certificate:
  - Certificate for application endpoint

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
go test
```
#### Performs: 
- Terraform init and apply
- Take application url from terraform response
- Perform http get on the / endpoint
- Terraform destroy

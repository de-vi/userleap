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

### miscellaneous
Has terraform code to setup project
```
cd miscellaneous
terraform init
terraform plan
terraform apply
```

#### Creates:
- S3 bucket to store state
- Dynamodb to create lock table
- S3 bucket to store load balancer access logs 

### terraform
Has code to build infrastructure and deploy application
```
cd terraform
terraform init
terraform plan
terraform apply
```

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
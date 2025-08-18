# Gatus Application with AWS Infrastructure

## What does it do?

A production-ready Gatus health monitoring application deployed on AWS using Terraform, ECS Fargate, and Application Load Balancer.
<img width="1132" height="795" alt="ecs-aws-proj drawio (2)" src="https://github.com/user-attachments/assets/6b09267e-5414-42b2-866a-c10f0a4a283f" />

## Quick Links

- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Project File Structure](#project-file-structure)
- [Infrastructure Components](#infrastructure-components)
  - [VPC & Networking](#vpc--networking)
  - [Load Balancer & SSL](#load-balancer--ssl)
  - [Container Orchestration](#container-orchestration)
- [Environment Strategy](#environment-strategy)
- [CI/CD & Automation](#cicd--automation)
- [Trade-offs and Design Decisions](#trade-offs-and-design-decisions)
- [Future Improvements](#future-improvements)

## Architecture

<img width="1316" height="922" alt="ecs-aws-proj drawio (3)" src="https://github.com/user-attachments/assets/7d459431-5ce5-4893-9c9b-a8a320f22399" />

### Quick Start
```bash
# Clone repository
git clone https://github.com/AbuCloud1/gatus-local.git
cd gatus-local

# Configure environment
cd terraform/environments/dev
# Update terraform.tfvars with your domain and ECR repository

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Build and deploy application
cd ../../garus-app
docker build -t gatuswebapp:latest .
docker tag gatuswebapp:latest your-ecr-repo:latest
docker push your-ecr-repo:latest
```


## Project File Structure

```
gatus-local/
├── garus-app/                 
│   ├── Dockerfile            
│   ├── config.yaml           
│   └── README.md             
├── terraform/                 
│   ├── environments/         
│   │   ├── dev/             
│   │   ├── staging/         
│   │   └── prod/           
│   └── modules/              
│       ├── vpc/              
│       ├── alb/              
│       ├── acm/             
│       ├── ecs-cluster/     
│       ├── ecs-service/      
│       ├── route53/          
│       └── dynamodb/         
├── .github/workflows/         
├── .pre-commit-config.yaml    
├── deploy-gatus.sh            
└── README.md                  
```

## Infrastructure Components
### VPC & Networking
- Multi-AZ VPC (10.0.0.0/16) with public & private subnets
- Internet Gateway for public access, NAT Gateways for private internet access
<img width="1634" height="581" alt="image" src="https://github.com/user-attachments/assets/bbd1d367-2b9f-48cd-aeca-28f1270e3846" />

### Load Balancer & SSL
- Application Load Balancer with HTTPS (ACM-managed certificate)
- Automatic HTTP→HTTPS redirection & health checks
<img width="1891" height="610" alt="Screenshot 2025-08-18 at 13 53 03" src="https://github.com/user-attachments/assets/47542430-fc33-4938-81d3-f91cd79cfa5e" />

### Container Orchestration
- ECS Fargate cluster with auto-scaling services

## Environment Strategy
- Isolated Dev, Staging & Prod environments
- Separate Terraform state & variables per environment
- Promotion workflow for changes
<img width="1297" height="375" alt="image" src="https://github.com/user-attachments/assets/05cde5d0-59fd-4edc-a48f-a25c7401be35" />


## CI/CD & Automation
- GitHub Actions: Terraform validation, Triviy, Checkov security scans, pre-commit hooks
<img width="1108" height="649" alt="Screenshot 2025-08-18 at 13 47 45" src="https://github.com/user-attachments/assets/fc479a5d-d617-475a-80d7-91a274fcc418" />

## Trade-offs and Design Decisions

**Infrastructure Architecture**:  
I went with Multi-AZ for better uptime and DR even though it costs more. Public and private subnets were set up for security, but it did add complexity and extra NAT costs. ECS Fargate was picked to avoid managing servers and speed up delivery, at the cost of losing some low-level control.

**Security and Compliance**:  
SSL ends at the load balancer which makes cert management easier but means traffic inside isn’t encrypted. Security Groups are more complex but give tighter network isolation. The VPC runs on a custom CIDR across multiple AZs to keep it production-ready and easy to grow later.

## Future Improvements

**Implemented Terraform Workspaces**:  
The way I set up my Terraformix, I didn't use Terraformix spaces. And Terraformix spaces would have easily alleviated some of the complexity.

**CI/CD Pipeline Enhancement**:  
Automate Docker builds, pushes, and Terraform runs. Add approvals for prod releases and run security scans in the pipeline.

**Infrastructure Security**:  
IAM policies can be refined to ensure the principle of least privilege is consistently applied, and CloudTrail integration could provide comprehensive audit logging for compliance purposes.

**Scalability and Resilience**:  
Add ECS auto-scaling, use blue-green or canary deploys to cut downtime, and add cross-region DR with backups and restores.


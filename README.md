# Gatus Application with AWS Infrastructure

## What does it do?

A production-ready Gatus health monitoring application deployed on AWS using Terraform, ECS Fargate, and Application Load Balancer.
<img width="1132" height="795" alt="ecs-aws-proj drawio (2)" src="https://github.com/user-attachments/assets/6b09267e-5414-42b2-866a-c10f0a4a283f" />

## Quick Links

- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Infrastructure Components](#infrastructure-components)
  - [VPC & Networking](#vpc--networking)
  - [Load Balancer & SSL](#load-balancer--ssl)
  - [Container Orchestration](#container-orchestration)
  - [Security Implementation](#security-implementation)
- [Environment Strategy](#environment-strategy)
- [CI/CD & Automation](#cicd--automation)
- [Trade-offs and Design Decisions](#trade-offs-and-design-decisions)
- [Future Improvements](#future-improvements)

## Architecture

<img width="1132" height="795" alt="ecs-aws-proj drawio (2)" src="https://github.com/user-attachments/assets/1067c524-3f89-46d1-a80e-ea9da3725471" />

## Tech Stack

- **Application**: [Gatus](https://github.com/TwiN/gatus) which is a health monitoring dashboard
- **Infrastructure**: Modular Terraform setup with remote state stored in S3 and state locking via DynamoDB
- **Container**: Docker with ECS Fargate
- **Load Balancer**: AWS Application Load Balancer with SSL termination
- **Security**: AWS Certificate Manager, Security Groups, VPC isolation
- **DNS**: AWS Route53 with custom domain management
- **Networking**: Multi-AZ VPC with public/private subnet architecture

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


## Project Structure

```
gatus-local/
├── garus-app/                 # Gatus application source
│   ├── Dockerfile            
│   ├── config.yaml           
│   └── README.md             
├── terraform/                 # Infrastructure as Code
│   ├── environments/         # Environment-specific configs
│   │   ├── dev/             
│   │   ├── staging/         
│   │   └── prod/           
│   └── modules/              # Reusable Terraform modules
│       ├── vpc/              
│       ├── alb/              
│       ├── acm/             
│       ├── ecs-cluster/     
│       ├── ecs-service/      
│       ├── route53/          
│       └── dynamodb/         
├── .github/workflows/         # CI/CD pipeline
├── .pre-commit-config.yaml    # Code quality hooks
├── deploy-gatus.sh            # Deployment automation
└── README.md                  # Project documentation
```

## Infrastructure Components
### VPC & Networking
- Multi-AZ VPC (10.0.0.0/16) with public & private subnets
- Internet Gateway for public access, NAT Gateways for private internet access

### Load Balancer & SSL
- Application Load Balancer with HTTPS (ACM-managed certificate)
- Automatic HTTP→HTTPS redirection & health checks

### Container Orchestration
- ECS Fargate cluster with auto-scaling services
- Task Definition: 256 CPU, 512MB memory

### Security Implementation
- Separate Security Groups for ALB & ECS
- IAM Roles with least privilege
- Private subnets for workloads, end-to-end TLS

## Environment Strategy
- Isolated Dev, Staging & Prod environments
- Separate Terraform state & variables per environment
- Promotion workflow for changes

## CI/CD & Automation
- GitHub Actions: Terraform validation, Checkov security scans, pre-commit hooks
- Target: Fully automated pipeline (cut deployment from 15min → 2min)

## Trade-offs and Design Decisions

**Infrastructure Architecture**:  
I went with Multi-AZ for better uptime and DR even though it costs more. Public and private subnets were set up for security, but it did add complexity and extra NAT costs. ECS Fargate was picked to avoid managing servers and speed up delivery, at the cost of losing some low-level control.

**Security and Compliance**:  
SSL ends at the load balancer which makes cert management easier but means traffic inside isn’t encrypted. Security Groups are more complex but give tighter network isolation. The VPC runs on a custom CIDR across multiple AZs to keep it production-ready and easy to grow later.

## Future Improvements

**CI/CD Pipeline Enhancement**:  
Automate Docker builds, pushes, and Terraform runs. Add approvals for prod releases and run security scans in the pipeline.

**Infrastructure Security**:  
IAM policies can be refined to ensure the principle of least privilege is consistently applied, and CloudTrail integration could provide comprehensive audit logging for compliance purposes.

**Scalability and Resilience**:  
Add ECS auto-scaling, use blue-green or canary deploys to cut downtime, and add cross-region DR with backups and restores.


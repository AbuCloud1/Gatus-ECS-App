# Gatus Application with AWS Infrastructure

## What does it do?

A production-ready Gatus health monitoring application deployed on AWS using Terraform, ECS Fargate, and Application Load Balancer.

## 📋 Table of Contents

- [🏗️ Architecture](#architecture)
- [🛠️ Tech Stack](#tech-stack)
- [🚀 Quick Start](#quick-start)
- [📁 Project Structure](#project-structure)
- [🏛️ Infrastructure Components](#infrastructure-components)
  - [🌐 VPC & Networking](#vpc--networking)
  - [⚖️ Load Balancer & SSL](#load-balancer--ssl)
  - [🐳 Container Orchestration](#container-orchestration)
  - [🔒 Security Implementation](#security-implementation)
- [🌍 Environment Strategy](#environment-strategy)
- [🔄 CI/CD & Automation](#cicd--automation)
- [🔐 Security and Compliance](#security-and-compliance)
- [📊 Monitoring and Observability](#monitoring-and-observability)
- [🚀 Future Improvements](#future-improvements)

## Architecture
<img width="1132" height="795" alt="ecs-aws-proj drawio (2)" src="https://github.com/user-attachments/assets/6b09267e-5414-42b2-866a-c10f0a4a283f" />

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
│   ├── Dockerfile            # Container configuration
│   ├── config.yaml           # Gatus monitoring configuration
│   └── README.md             # Application documentation
├── terraform/                 # Infrastructure as Code
│   ├── environments/         # Environment-specific configs
│   │   ├── dev/             # Development environment
│   │   ├── staging/         # Staging environment
│   │   └── prod/            # Production environment
│   └── modules/              # Reusable Terraform modules
│       ├── vpc/              # VPC and networking
│       ├── alb/              # Application Load Balancer
│       ├── acm/              # SSL certificate management
│       ├── ecs-cluster/      # ECS cluster configuration
│       ├── ecs-service/      # ECS service and task definition
│       ├── route53/          # DNS management
│       └── dynamodb/         # State locking (planned)
├── .github/workflows/         # CI/CD pipeline
├── .pre-commit-config.yaml    # Code quality hooks
├── deploy-gatus.sh            # Deployment automation
└── README.md                  # Project documentation
```

## Infrastructure Components

### VPC & Networking
- **VPC CIDR**: 10.0.0.0/16 with multi-AZ deployment
- **Public Subnets**: 10.0.1.0/24 (eu-west-1a), 10.0.2.0/24 (eu-west-1b)
- **Private Subnets**: 10.0.3.0/24 (eu-west-1a), 10.0.4.0/24 (eu-west-1b)
- **Internet Gateway**: Public internet access
- **NAT Gateways**: Private subnet internet access with high availability

### Load Balancer & SSL
- **Application Load Balancer**: HTTPS termination on port 443
- **SSL Certificate**: ACM-managed with automatic renewal
- **HTTP Redirect**: Automatic HTTP to HTTPS redirection
- **Health Checks**: Application endpoint monitoring on /health

### Container Orchestration
- **ECS Cluster**: Fargate launch type for serverless management
- **Task Definition**: CPU 256, Memory 512MB with resource constraints
- **Service Configuration**: Auto-scaling with desired count management

### Security Implementation
- **Security Groups**: Separate groups for ALB and ECS tasks
- **IAM Roles**: Least privilege access with execution roles
- **Network Isolation**: Private subnets for application workloads
- **SSL/TLS**: End-to-end encryption with certificate management (ACM)

## Environment Strategy

### Multi-Environment Deployment & Environment Isolation
- **Environment Isolation Development**: Development, Staging and Production environment
- **Separate State Files**: Each environment maintains independent Terraform state
- **Consistent Infrastructure**: Identical components with environment-specific variables
- **Promotion Workflow**: Infrastructure changes progress through environments
- **State locking**: Prevents others from acquiring the lock and potentially corrupting state

## CI/CD & Automation

### GitHub Actions Pipeline
- **Terraform Validation**: Syntax and configuration validation
- **Security Scanning**: Checkov integration for security best practices
- **Code Quality**: Pre-commit hooks for formatting and validation
- **Infrastructure Testing**: Validation before deployment

### Pre-commit Hooks
- **Terraform Formatting**: Automatic code formatting
- **Security Validation**: Checkov security scanning
- **Code Quality**: YAML validation and whitespace checking

### Deployment Automation
- **Current State**: Manual deployment with deployment scripts
- **Target State**: Fully automated CI/CD pipeline
- **Expected Improvement**: 87% reduction in deployment time (15min → 2min)

## Security and Compliance

### Network Security
- **VPC Isolation**: Private subnets for application workloads
- **Security Groups**: Layer 3-4 security with port restrictions
- **SSL/TLS**: End-to-end encryption with certificate management

### Access Control
- **IAM Roles**: Least privilege access for ECS tasks
- **Security Groups**: Network-level access control
- **Certificate Management**: Automated SSL certificate renewal

### Compliance Features
- **Audit Logging**: Infrastructure change tracking
- **Security Scanning**: Automated security validation
- **Documentation**: Comprehensive security and deployment documentation

## Trade-offs and Design Decisions

**Infrastructure Architecture**:  
I went with Multi-AZ for better uptime and DR even though it costs more. Public and private subnets were set up for security, but it did add complexity and extra NAT costs. ECS Fargate was picked to avoid managing servers and speed up delivery, at the cost of losing some low-level control.

**Security and Compliance**:  
SSL ends at the load balancer which makes cert management easier but means traffic inside isn’t encrypted. Security Groups are more complex but give tighter network isolation. The VPC runs on a custom CIDR across multiple AZs to keep it production-ready and easy to grow later.

**Operational Considerations**:  
Deployments are manual for now to keep oversight over speed. Docker builds are basic to keep things moving quickly, though they’re not yet optimized.

## Future Improvements

There are several enhancements that can be made to the project over time to improve scalability, security, maintainability, and overall performance.

**CI/CD Pipeline Enhancement**:  
Automate Docker builds, pushes, and Terraform runs. Add approvals for prod releases and run security scans in the pipeline.

**Infrastructure Security**:  
IAM policies can be refined to ensure the principle of least privilege is consistently applied, and CloudTrail integration could provide comprehensive audit logging for compliance purposes.

**Container Optimization**:  
Use multi-stage builds to shrink images and speed builds. Add vuln scanning and caching, plus better health checks for containers.

**Monitoring and Observability**:  
Set up central logging like ELK to tie logs together. Add app performance monitoring, automated alerts, and cost tracking.

**Scalability and Resilience**:  
Add ECS auto-scaling, use blue-green or canary deploys to cut downtime, and add cross-region DR with backups and restores.


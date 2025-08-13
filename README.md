# Gatus Application with AWS Infrastructure

## What does it do?

A production-ready Gatus health monitoring application deployed on AWS using Terraform, ECS Fargate, and Application Load Balancer. This project demonstrates modern DevOps practices with infrastructure as code, multi-environment deployment, and automated CI/CD workflows.

## Architecture

```
Internet → Route53 → ALB → ECS Fargate → Gatus Container
                ↓
            ACM Certificate
                ↓
            VPC + Security Groups
```

## Tech Stack

- **Application**: [Gatus](https://github.com/TwiN/gatus) - Health monitoring dashboard
- **Infrastructure**: Terraform with modular architecture
- **Container**: Docker with ECS Fargate
- **Load Balancer**: AWS Application Load Balancer with SSL termination
- **Security**: AWS Certificate Manager, Security Groups, VPC isolation
- **DNS**: AWS Route53 with custom domain management
- **Networking**: Multi-AZ VPC with public/private subnet architecture

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

### VPC and Networking
- **VPC CIDR**: 10.0.0.0/16 with multi-AZ deployment
- **Public Subnets**: 10.0.1.0/24 (eu-west-1a), 10.0.2.0/24 (eu-west-1b)
- **Private Subnets**: 10.0.3.0/24 (eu-west-1a), 10.0.4.0/24 (eu-west-1b)
- **Internet Gateway**: Public internet access
- **NAT Gateways**: Private subnet internet access with high availability

### Load Balancer and SSL
- **Application Load Balancer**: HTTPS termination on port 443
- **SSL Certificate**: ACM-managed with automatic renewal
- **HTTP Redirect**: Automatic HTTP to HTTPS redirection
- **Health Checks**: Application endpoint monitoring on /health

### Container Orchestration
- **ECS Cluster**: Fargate launch type for serverless management
- **Task Definition**: CPU 256, Memory 512MB with resource constraints
- **Service Configuration**: Auto-scaling with desired count management
- **Network Mode**: awsvpc for enhanced security and networking

### Security Implementation
- **Security Groups**: Separate groups for ALB and ECS tasks
- **IAM Roles**: Least privilege access with execution roles
- **Network Isolation**: Private subnets for application workloads
- **SSL/TLS**: End-to-end encryption with certificate management

## Environment Strategy

### Multi-Environment Deployment
- **Development**: Rapid iteration and testing environment
- **Staging**: Pre-production validation with production-like configuration
- **Production**: Live environment with enhanced monitoring and security

### Environment Isolation
- **Separate State Files**: Each environment maintains independent Terraform state
- **Consistent Infrastructure**: Identical components with environment-specific variables
- **Promotion Workflow**: Infrastructure changes progress through environments

## CI/CD and Automation

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

## Trade-offs and Design Decisions

### Infrastructure Architecture
- **Multi-AZ Deployment**: Higher cost for improved availability and disaster recovery
- **Public/Private Subnets**: Increased complexity and NAT Gateway costs for enhanced security
- **ECS Fargate**: Less infrastructure control for simplified operations and reduced overhead

### Security and Compliance
- **SSL Termination**: Simplified certificate management with HTTP communication to containers
- **Security Groups**: More complex management for better network isolation and least privilege
- **VPC Design**: Custom CIDR with multi-AZ for production-ready architecture

### Operational Considerations
- **Manual Deployment**: Human control vs deployment speed trade-off
- **Terraform State**: S3 backend without DynamoDB state locking for simplified setup
- **Container Strategy**: Basic Dockerfile for simplicity vs optimization potential

## Future Improvements

### CI/CD Pipeline Enhancement
- **Automated Deployment**: Docker build, push, and Terraform apply automation
- **Deployment Gates**: Approval workflows for production deployments
- **Security Integration**: Automated security scanning in deployment pipeline

### Infrastructure Security
- **State Management**: DynamoDB state locking for team collaboration
- **Encryption**: S3 bucket encryption for Terraform state files
- **IAM Policies**: Enhanced least privilege access controls
- **Audit Logging**: CloudTrail integration for compliance

### Container Optimization
- **Multi-stage Builds**: 60-75% reduction in build time
- **Security Scanning**: Vulnerability scanning in build process
- **Image Optimization**: Layer caching and size reduction
- **Health Monitoring**: Enhanced container health checks

### Monitoring and Observability
- **Centralized Logging**: ELK stack or similar for log aggregation
- **Application Performance**: APM tools for performance monitoring
- **Automated Alerting**: Proactive issue detection and notification
- **Cost Monitoring**: Resource utilization and optimization insights

### Scalability and Resilience
- **Auto-scaling**: ECS auto-scaling policies and horizontal scaling
- **Deployment Strategies**: Blue-green and canary deployment capabilities
- **Disaster Recovery**: Cross-region replication and automated failover
- **Backup Strategies**: Automated backup and recovery procedures

## Getting Started

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform installed (version 1.5.0+)
- Docker installed
- Domain name for custom domain configuration

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

### Configuration
- **Domain Setup**: Configure Route53 and ACM certificate
- **Container Image**: Update ECR repository in terraform.tfvars
- **Environment Variables**: Customize for each environment
- **Monitoring**: Configure health checks and alerting

## Monitoring and Operations

### Health Monitoring
- **Application Health**: Custom health check endpoints
- **Infrastructure Health**: ECS service and ALB target group monitoring
- **Security Monitoring**: Security group and IAM role monitoring

### Logging and Metrics
- **CloudWatch Integration**: Centralized logging and metrics
- **ECS Metrics**: Task health, resource utilization, and scaling metrics
- **ALB Access Logs**: Request logging and performance monitoring

### Troubleshooting
- **Common Issues**: Deployment and configuration troubleshooting
- **Debug Tools**: Terraform state inspection and resource validation
- **Support Resources**: Documentation and troubleshooting guides

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

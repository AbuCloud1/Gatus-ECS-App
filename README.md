# 🚀 Gatus Application with AWS Infrastructure

A production-ready Gatus health monitoring application deployed on AWS using Terraform, ECS Fargate, and Application Load Balancer.

## 🌟 Features

- **Gatus Health Dashboard**: Real-time monitoring of endpoint health
- **Custom Domain**: Accessible at `https://tm.easyumrahs.com`
- **SSL/TLS Encryption**: Fully secured with AWS Certificate Manager
- **Auto-scaling**: ECS Fargate with load balancer
- **Infrastructure as Code**: Complete Terraform configuration
- **Multi-environment Support**: Dev, Staging, and Production configurations

## 🏗️ Architecture

```
Internet → Route53 → ALB → ECS Fargate → Gatus Container
                ↓
            ACM Certificate
                ↓
            VPC + Security Groups
```

## 🛠️ Tech Stack

- **Application**: [Gatus](https://github.com/TwiN/gatus) - Health monitoring dashboard
- **Infrastructure**: Terraform
- **Container**: Docker
- **Orchestration**: AWS ECS Fargate
- **Load Balancer**: AWS Application Load Balancer
- **SSL**: AWS Certificate Manager
- **DNS**: AWS Route53
- **Networking**: AWS VPC with public/private subnets

## 📁 Project Structure

```
gatus-local/
├── garus-app/                 # Gatus application source
│   ├── Dockerfile            # Multi-platform Docker image
│   ├── config.yaml           # Gatus configuration
│   └── README.md             # Application documentation
├── terraform/                 # Infrastructure as Code
│   ├── environments/         # Environment-specific configs
│   │   ├── dev/             # Development environment
│   │   ├── staging/         # Staging environment
│   │   └── prod/            # Production environment
│   └── modules/              # Reusable Terraform modules
│       ├── acm/              # SSL certificate management
│       ├── alb/              # Application Load Balancer
│       ├── ecs-cluster/      # ECS cluster configuration
│       ├── ecs-service/      # ECS service and task definition
│       ├── route53/          # DNS management
│       └── vpc/              # VPC and networking
├── deploy-gatus.sh           # Deployment script
├── TROUBLESHOOTING.md        # Troubleshooting guide
└── README.md                 # This file
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed
- Docker installed
- Domain name (e.g., `easyumrahs.com`)

### 1. Clone and Setup

```bash
git clone https://github.com/AbuCloud1/gatus-local.git
cd gatus-local
```

### 2. Configure Environment

Update `terraform/environments/dev/terraform.tfvars`:

```hcl
# Domain configuration
domain_name = "your-domain.com"
record_name = "tm"  # Creates tm.your-domain.com

# Container configuration
container_image = "your-ecr-repo:latest"
container_port  = 8080  # Gatus default port
```

### 3. Deploy Infrastructure

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

### 4. Build and Push Docker Image

```bash
cd ../../garus-app
docker build --platform linux/amd64 -t gatuswebapp:latest .
docker tag gatuswebapp:latest your-ecr-repo:latest
docker push your-ecr-repo:latest
```

### 5. Access Application

Your Gatus dashboard will be available at:
- **HTTPS**: `https://tm.your-domain.com`
- **Health Check**: `https://tm.your-domain.com/health`

## 🔧 Configuration

### Gatus Configuration

The `garus-app/config.yaml` file configures:
- Health check intervals
- Endpoint monitoring
- Alert conditions
- Dashboard settings

### Infrastructure Configuration

Each environment has its own configuration:
- **Dev**: Development testing environment
- **Staging**: Pre-production validation
- **Production**: Live production environment

## 📊 Monitoring

- **Health Checks**: Automatic endpoint monitoring
- **Logs**: CloudWatch integration
- **Metrics**: ECS service metrics
- **Alerts**: Configurable health conditions

## 🔒 Security

- **SSL/TLS**: End-to-end encryption
- **Security Groups**: Network-level security
- **IAM Roles**: Least privilege access
- **VPC**: Isolated network environment

## 🚨 Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Abubaker Omer** - DevOps Engineer
- GitHub: [@AbuCloud1](https://github.com/AbuCloud1)
- LinkedIn: [Abubaker Omer](https://linkedin.com/in/abubaker-omer-939462185)

## 🙏 Acknowledgments

- [Gatus](https://github.com/TwiN/gatus) - Health monitoring application
- [Terraform](https://terraform.io) - Infrastructure as Code
- [AWS](https://aws.amazon.com) - Cloud infrastructure services

---

⭐ **Star this repository if you find it helpful!**

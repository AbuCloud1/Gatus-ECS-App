# Gatus Application Troubleshooting Guide

## Issue: Website works with NGINX but not with custom Gatus image

### Root Cause
The main issue was a **port mismatch**:
- **NGINX**: Runs on port 80 ✅
- **Gatus**: Runs on port 8080 by default ❌
- **Infrastructure**: Was configured for port 80 ❌

### What We Fixed
1. ✅ Updated `container_port` from 80 to 8080 in `terraform.tfvars`
2. ✅ Updated ALB health check path from `/` to `/health`
3. ✅ Created deployment script with proper validation

### Current Configuration
```hcl
# terraform/environments/dev/terraform.tfvars
container_port = 8080  # Gatus default port
```

### Deployment Steps
1. **Update ECR Image URL**: Replace `your-ecr-repo-url:latest` in `terraform.tfvars` with your actual ECR image URL
2. **Run Deployment**: Execute `./deploy-gatus.sh` from the project root
3. **Verify**: Check ECS service status and ALB health

### Common Issues & Solutions

#### 1. Container Not Starting
**Symptoms**: ECS tasks failing to start
**Check**:
- ECS task logs in CloudWatch
- Container image URL is correct
- ECR repository permissions

**Solution**:
```bash
# Check ECS task logs
aws logs describe-log-groups --log-group-name-prefix "/ecs/dev-gatuswebapp"
```

#### 2. Health Check Failing
**Symptoms**: ALB target group showing unhealthy
**Check**:
- Container is listening on port 8080
- Health check path `/health` returns 200
- Security groups allow traffic

**Solution**:
```bash
# Test health endpoint locally
curl http://localhost:8080/health

# Check security group rules
aws ec2 describe-security-groups --group-ids <sg-id>
```

#### 3. Port Binding Issues
**Symptoms**: Container starts but not accessible
**Check**:
- Port mappings in ECS task definition
- Container exposes port 8080
- Security group ingress rules

**Solution**:
```hcl
# Verify in ECS service module
portMappings = [
  {
    containerPort = 8080
    hostPort      = 8080
    protocol      = "tcp"
  }
]
```

#### 4. DNS Resolution Issues
**Symptoms**: Domain not resolving
**Check**:
- Route53 record exists
- ACM certificate is valid
- ALB DNS name is correct

**Solution**:
```bash
# Check Route53 records
aws route53 list-resource-record-sets --hosted-zone-id <zone-id>

# Verify certificate
aws acm describe-certificate --certificate-arn <cert-arn>
```

### Testing Your Gatus Application

#### 1. Local Testing
```bash
# Build and test locally
cd garus-app
docker build -t gatus-test .
docker run -p 8080:8080 gatus-test

# Test endpoints
curl http://localhost:8080/health
curl http://localhost:8080/
```

#### 2. ECR Testing
```bash
# Test ECR image locally
docker pull <your-ecr-url>:latest
docker run -p 8080:8080 <your-ecr-url>:latest
```

#### 3. Production Testing
```bash
# Test deployed application
curl -k https://<your-domain>/health
curl -k https://<your-domain>/
```

### Monitoring & Debugging

#### 1. ECS Service
```bash
# Check service status
aws ecs describe-services --cluster <cluster-name> --services <service-name>

# Check task status
aws ecs list-tasks --cluster <cluster-name> --service-name <service-name>
```

#### 2. Load Balancer
```bash
# Check target group health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>

# Check ALB status
aws elbv2 describe-load-balancers --names <alb-name>
```

#### 3. Security Groups
```bash
# Check security group rules
aws ec2 describe-security-groups --group-ids <sg-id>
```

### Rollback Plan
If issues persist, you can quickly rollback to NGINX:
```hcl
# terraform/environments/dev/terraform.tfvars
container_image = "nginx:alpine"
container_port  = 80
```

Then run:
```bash
cd terraform/environments/dev
terraform apply -auto-approve
```

### Next Steps
1. ✅ Deploy with corrected port configuration
2. ✅ Monitor ECS service and ALB health
3. ✅ Test application endpoints
4. ✅ Verify monitoring and alerting
5. ✅ Document any additional configuration needed

### Support
If you continue to experience issues:
1. Check CloudWatch logs for detailed error messages
2. Verify all security group rules are correct
3. Ensure ECR image is accessible and properly configured
4. Test the container locally before deployment


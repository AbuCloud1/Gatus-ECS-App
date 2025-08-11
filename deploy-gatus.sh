#!/bin/bash

# Deployment script for Gatus application
# This script helps deploy the Gatus app with the correct port configuration

set -e

echo "🚀 Deploying Gatus application..."

# Check if we're in the right directory
if [ ! -f "terraform/environments/dev/main.tf" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Navigate to dev environment
cd terraform/environments/dev

echo "📋 Current configuration:"
echo "   Container port: $(grep 'container_port' terraform.tfvars | cut -d'=' -f2 | tr -d ' ')"
echo "   Container image: $(grep 'container_image' terraform.tfvars | cut -d'=' -f2 | tr -d ' ' | tr -d '"')"

echo ""
echo "⚠️  IMPORTANT: Make sure to update the container_image in terraform.tfvars with your actual ECR image URL!"
echo "   Current value: $(grep 'container_image' terraform.tfvars | cut -d'=' -f2 | tr -d ' ' | tr -d '"')"
echo ""

read -p "Have you updated the container_image with your ECR URL? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please update the container_image in terraform.tfvars first"
    exit 1
fi

echo "🔍 Validating Terraform configuration..."
terraform init
terraform validate

echo "📊 Planning Terraform changes..."
terraform plan

echo ""
read -p "Do you want to apply these changes? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

echo "🚀 Applying Terraform changes..."
terraform apply -auto-approve

echo ""
echo "✅ Deployment completed!"
echo ""
echo "🔍 To check the status of your Gatus application:"
echo "   1. Check ECS service status in AWS Console"
echo "   2. Check ALB target group health"
echo "   3. Test the application at: https://$(terraform output -raw domain_name)"
echo ""
echo "📝 If you encounter issues:"
echo "   - Check ECS task logs for any startup errors"
echo "   - Verify the container is listening on port 8080"
echo "   - Check ALB target group health status"
echo "   - Ensure security groups allow traffic on port 8080"


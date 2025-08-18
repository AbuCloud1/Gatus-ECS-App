vpc_name             = "Main VPC"
region               = "eu-west-1"
vpc_cidr_block       = "10.0.0.0/16"
availability_zones   = ["eu-west-1a", "eu-west-1b"]
subnet_name          = "subnet"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

environment = "prod"
domain_name = "easyumrahs.com"
record_name = "tm"
family = "prod-gatuswebapp"
service_name = "prod-gatuswebapp-service"
container_image = "847025106966.dkr.ecr.eu-west-1.amazonaws.com/gatuswebapp:latest"
container_name = "prod-gatuswebapp"
container_port = 8080
desired_count = 2
cpu = 512
memory = 1024

key_name    = "master-key"

instance_type = "t3.micro"
user_data     = <<-EOF
  #!/bin/bash
  sudo amazon-linux-extras install -y nginx1.12
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
  
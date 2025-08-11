resource "aws_ecs_cluster" "ecs_cluster" {
 name = "${var.environment}-gatus-ecs-cluster"
   tags = {
    Name      = "${var.environment}-app-ecs-tf"
    ManagedBy = "Terraform"
  }
}

# Check if table already exists
data "aws_dynamodb_table" "existing" {
  name = "terraform-state-lock"
  count = 1
}

# Only create if it doesn't exist
resource "aws_dynamodb_table" "terraform_state_lock" {
  count = data.aws_dynamodb_table.existing[0].id == null ? 1 : 0
  
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-lock"
    Environment = var.environment
    Purpose     = "Terraform state locking"
  }
}

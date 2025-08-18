output "table_name" {
  description = "Name of the DynamoDB table"
  value       = length(aws_dynamodb_table.terraform_state_lock) > 0 ? aws_dynamodb_table.terraform_state_lock[0].name : data.aws_dynamodb_table.existing[0].name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = length(aws_dynamodb_table.terraform_state_lock) > 0 ? aws_dynamodb_table.terraform_state_lock[0].arn : data.aws_dynamodb_table.existing[0].arn
}

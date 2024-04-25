
resource "aws_dynamodb_table" "state_locking" {
  name     = "dynamodb-state-information"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

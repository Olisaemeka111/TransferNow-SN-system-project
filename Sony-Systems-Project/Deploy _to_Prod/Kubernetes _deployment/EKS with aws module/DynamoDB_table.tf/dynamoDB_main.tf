provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

resource "aws_dynamodb_table" "tf_state_lock-2" {
  name           = "tf-state-lock-2"
  billing_mode   = "PAY_PER_REQUEST" # Change to "PROVISIONED" if needed
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

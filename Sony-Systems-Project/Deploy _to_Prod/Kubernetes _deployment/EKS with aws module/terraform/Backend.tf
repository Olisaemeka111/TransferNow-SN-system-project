terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket-fvnvkq"
    key            = "terraform.tfstate" # You can customize the key name if needed
    region         = "us-east-1"         # Replace with your desired AWS region
    encrypt        = true
    dynamodb_table = "tf-state-lock-2" # Specify the name of your DynamoDB table for locking

  }
}


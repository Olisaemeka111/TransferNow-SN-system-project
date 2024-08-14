provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "my-tf-state-bucket-${lower(random_string.bucket_suffix.result)}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls     = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "tf_state_backend_policy" {
  name        = "tf-state-backend-policy"
  description = "Policy for Terraform S3 backend access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ],
        Effect   = "Allow",
        Resource = aws_s3_bucket.tf_state_bucket.arn,
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
        ],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.tf_state_bucket.arn}/*",
      },
    ],
  })
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"  # Replace with your desired username
}

resource "aws_iam_policy_attachment" "tf_state_backend_attachment" {
  name       = "tf-state-backend-attachment"  # Specify the attachment name
  policy_arn = aws_iam_policy.tf_state_backend_policy.arn
  users      = [aws_iam_user.terraform_user.name]
}

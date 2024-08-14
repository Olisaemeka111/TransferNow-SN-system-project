output "bucket_name" {
  value = aws_s3_bucket.tf_state_bucket.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.tf_state_bucket.id
}
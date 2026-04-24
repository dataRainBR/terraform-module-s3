output "bucket_id" {
  description = "ID (nome) do bucket S3."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN do bucket S3."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket S3."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name do bucket S3."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "Route53 hosted zone ID do bucket (para alias records)."
  value       = aws_s3_bucket.this.hosted_zone_id
}

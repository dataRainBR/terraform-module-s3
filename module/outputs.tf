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

output "ssm_path_bucket_name" {
  description = "SSM Parameter path para bucket name (quando ssm_path_prefix definido)."
  value       = var.ssm_path_prefix == null ? null : aws_ssm_parameter.bucket_name[0].name
}

output "ssm_path_bucket_arn" {
  description = "SSM Parameter path para bucket ARN (quando ssm_path_prefix definido)."
  value       = var.ssm_path_prefix == null ? null : aws_ssm_parameter.bucket_arn[0].name
}

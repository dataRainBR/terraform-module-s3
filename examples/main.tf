module "s3_private" {
  source = "../module"

  bucket_name        = "meu-bucket-privado-prod"
  versioning_enabled = true
  encryption_type    = "AES256"

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

module "s3_with_crr" {
  source = "../module"

  bucket_name        = "meu-bucket-dr-prod"
  versioning_enabled = true
  encryption_type    = "AES256"

  replication_configuration = {
    role_arn = "arn:aws:iam::123456789012:role/s3-replication-role"
    rules = [{
      id                        = "replicate-all"
      destination_bucket_arn    = "arn:aws:s3:::meu-bucket-dr-us-east-1"
      destination_storage_class = "STANDARD_IA"
    }]
  }

  tags = {
    Environment = "prod"
    Backup      = "true"
    ManagedBy   = "Terraform"
  }
}

# S3 Module

Cria um bucket Amazon S3 com suporte a versionamento, criptografia server-side, controle de acesso público, lifecycle rules, CORS e Cross-Region Replication (CRR) para Disaster Recovery.

**Última versão:** `0.1.0`

## Requisitos Mínimos

- Para CRR: `versioning_enabled = true` e IAM role com permissão de replicação no bucket de origem e destino.
- Para criptografia KMS: fornecer `kms_key_arn`.

## Exemplos

### Bucket privado simples
```hcl
module "s3_private" {
  source = "git::https://github.com/dataRainBR/terraform-module-s3.git//module?ref=0.1.0"

  bucket_name = "meu-bucket-privado"
  tags        = { Environment = "prod" }
}
```

### Bucket com versionamento e CRR para DR
```hcl
module "s3_with_crr" {
  source = "git::https://github.com/dataRainBR/terraform-module-s3.git//module?ref=0.1.0"

  bucket_name        = "plataforma-fotos-prod"
  versioning_enabled = true

  replication_configuration = {
    role_arn = aws_iam_role.replication.arn
    rules = [{
      id                        = "replicate-to-us-east-1"
      destination_bucket_arn    = "arn:aws:s3:::plataforma-fotos-prod-dr"
      destination_storage_class = "STANDARD_IA"
    }]
  }

  tags = { Environment = "prod", Backup = "true" }
}
```

### Bucket público (website/CDN)
```hcl
module "s3_public" {
  source = "git::https://github.com/dataRainBR/terraform-module-s3.git//module?ref=0.1.0"

  bucket_name             = "plataforma-assets-public"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  object_ownership        = "BucketOwnerPreferred"

  cors_rules = [{
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://meusite.com"]
  }]

  tags = { Environment = "prod" }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

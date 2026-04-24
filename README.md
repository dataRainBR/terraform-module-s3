# terraform-module-s3

Terraform module para criação de buckets Amazon S3 com suporte a versionamento, criptografia, controle de acesso público, lifecycle rules, CORS e Cross-Region Replication (CRR) para Disaster Recovery.

## Uso

```hcl
module "s3" {
  source = "git::https://github.com/dataRainBR/terraform-module-s3.git//module?ref=0.1.0"

  bucket_name        = "meu-bucket"
  versioning_enabled = true

  tags = { Environment = "prod" }
}
```

Consulte `examples/` para casos de uso completos.

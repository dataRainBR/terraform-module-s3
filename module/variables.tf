variable "bucket_name" {
  description = "Nome do bucket S3. Deve ser globalmente único."
  type        = string
}

variable "force_destroy" {
  description = "Permite destruir o bucket mesmo com objetos. Usar false em produção."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita versionamento. Obrigatório para Cross-Region Replication (CRR)."
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "Tipo de criptografia server-side: AES256 ou aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption_type)
    error_message = "encryption_type deve ser 'AES256' ou 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "ARN da chave KMS. Obrigatório quando encryption_type = 'aws:kms'."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Override explícito de bucket_key_enabled. Default null = auto (true para KMS, false para AES256). Útil quando AES256 + bucket key é desejado para reduzir custos."
  type        = bool
  default     = null
}

variable "block_public_acls" {
  description = "Bloqueia ACLs públicas."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloqueia políticas públicas."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignora ACLs públicas existentes."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringe acesso público ao bucket."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Controle de propriedade de objetos: BucketOwnerEnforced, BucketOwnerPreferred ou ObjectWriter."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership deve ser 'BucketOwnerEnforced', 'BucketOwnerPreferred' ou 'ObjectWriter'."
  }
}

variable "lifecycle_rules" {
  description = "Regras de lifecycle para expiração e transição de objetos."
  type = list(object({
    id      = string
    enabled = optional(bool, true)
    prefix  = optional(string, "")

    expiration_days                    = optional(number, null)
    noncurrent_version_expiration_days = optional(number, null)

    transition_days          = optional(number, null)
    transition_storage_class = optional(string, null)

    abort_incomplete_multipart_days = optional(number, 7)
  }))
  default = []
}

variable "cors_rules" {
  description = "Regras CORS para o bucket."
  type = list(object({
    allowed_headers = optional(list(string), ["*"])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 3000)
  }))
  default = []
}

variable "replication_configuration" {
  description = "Configuração de Cross-Region Replication (CRR). Requer versioning_enabled = true."
  type = object({
    role_arn = string
    rules = list(object({
      id                        = string
      status                    = optional(string, "Enabled")
      destination_bucket_arn    = string
      destination_storage_class = optional(string, "STANDARD")
      replica_kms_key_id        = optional(string, null)
      filter_prefix             = optional(string, "")
    }))
  })
  default = null
}

variable "bucket_policy" {
  description = "Documento JSON da política do bucket. Nulo ignora a criação da política."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags a serem aplicadas ao bucket."
  type        = map(string)
  default     = {}
}

variable "ssm_path_prefix" {
  description = <<-EOT
    Quando setado, módulo cria SSM Parameters de discoverability:
      <prefix>/bucket_name → bucket id (= nome)
      <prefix>/arn         → bucket ARN
    Pattern recomendado: /<org>/<service>/s3-<key>
    Mantém SSMs em paridade com o ciclo de vida do bucket (DR-portable).
  EOT
  type        = string
  default     = null
}

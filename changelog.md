# Changelog
Todas as anotação sobre as mudanças feitas nesse projeto podem ser encontradas nesse arquivo.

As anotações, seguem o padrão abaixo:
* `Added`  para novas funcionalidades.
* `Changed`  para alterações em funcionalidades existentes.
* `Deprecated`  para funcionalidades que estão para ser removidas.
* `Removed`  para funcionalidades removidas nesta versão.
* `Fixed`  para qualquer correção de bug.
* `Security`  em caso de vulnerabilidades.
> Toda anotação contém a versão e uma descrição do que foi feito nela.

## 0.1.0

### Added
- Criação de bucket S3 com criptografia server-side (AES256 ou KMS)
- Controle de acesso público (block_public_acls, block_public_policy, etc.)
- Versionamento configurável (pré-requisito para CRR)
- Ownership controls (BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter)
- Lifecycle rules com expiração, transição de storage class e abort multipart
- CORS rules configuráveis
- Cross-Region Replication (CRR) com suporte a filtro por prefixo e KMS no destino
- Bucket policy opcional via documento JSON

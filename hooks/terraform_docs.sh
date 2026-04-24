#!/bin/bash

set -e

# Função para verificar se terraform-docs está instalado
check_terraform_docs() {
    if command -v terraform-docs &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para instalar terraform-docs
install_terraform_docs() {
    echo "terraform-docs não encontrado. Instalando..."

    # Detectar OS e arquitetura
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    # Mapear arquitetura
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        *)
            echo "Arquitetura não suportada: $ARCH"
            exit 1
            ;;
    esac

    # Versão do terraform-docs
    VERSION="v0.19.0"

    # URL de download
    URL="https://github.com/terraform-docs/terraform-docs/releases/download/${VERSION}/terraform-docs-${VERSION}-${OS}-${ARCH}.tar.gz"

    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    # Baixar e extrair
    echo "Baixando terraform-docs ${VERSION} para ${OS}-${ARCH}..."
    curl -Lo terraform-docs.tar.gz "$URL"
    tar -xzf terraform-docs.tar.gz

    # Instalar no PATH
    if [ -w "/usr/local/bin" ]; then
        sudo mv terraform-docs /usr/local/bin/
    else
        # Fallback para diretório local
        mkdir -p "$HOME/.local/bin"
        mv terraform-docs "$HOME/.local/bin/"
        export PATH="$HOME/.local/bin:$PATH"
    fi

    # Limpar
    cd - > /dev/null
    rm -rf "$TEMP_DIR"

    echo "terraform-docs instalado com sucesso!"
}

# Verificar se terraform-docs está instalado
if ! check_terraform_docs; then
    install_terraform_docs
fi

# Executar terraform-docs apenas para a pasta module/
if [ -d "module" ]; then
    echo "Gerando documentação para: module/"
    cd module

    # Gerar documentação com terraform-docs
    terraform-docs markdown table --output-file README.md --output-mode inject ./

    # Baixar e executar terraform-examples
    echo "Gerando exemplos para: module/"
    curl -Lso terraform-examples \
        https://raw.githubusercontent.com/davimmt/terraform-examples/main/main.py

    # Executar com tratamento de erro
    if python3 terraform-examples; then
        echo "Exemplos gerados com sucesso!"
    else
        echo "Aviso: Falha ao gerar exemplos, mas continuando..."
    fi

    # Limpar arquivo temporário
    rm -f terraform-examples

    cd - > /dev/null
else
    echo "Pasta module/ não encontrada"
fi

echo "Documentação e exemplos Terraform gerados com sucesso!"

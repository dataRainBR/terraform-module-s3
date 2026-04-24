#!/bin/bash

set -e

# Função para verificar se trivy está instalado
check_trivy() {
    if command -v trivy &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para instalar trivy
install_trivy() {
    echo "Trivy não encontrado. Instalando..."
    
    # Detectar OS e arquitetura
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    # Mapear arquitetura
    case $ARCH in
        x86_64)
            ARCH="64bit"
            ;;
        aarch64|arm64)
            ARCH="ARM64"
            ;;
        *)
            echo "Arquitetura não suportada: $ARCH"
            exit 1
            ;;
    esac
    
    # Versão do trivy
    VERSION="0.48.3"
    
    # URL de download
    URL="https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_${OS^}-${ARCH}.tar.gz"
    
    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Baixar e extrair
    echo "Baixando Trivy ${VERSION} para ${OS}-${ARCH}..."
    curl -Lo trivy.tar.gz "$URL"
    tar -xzf trivy.tar.gz
    
    # Instalar no PATH
    if [ -w "/usr/local/bin" ]; then
        sudo mv trivy /usr/local/bin/
    else
        # Fallback para diretório local
        mkdir -p "$HOME/.local/bin"
        mv trivy "$HOME/.local/bin/"
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Limpar
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    echo "Trivy instalado com sucesso!"
}

# Verificar se trivy está instalado
if ! check_trivy; then
    install_trivy
fi

# Executar trivy scan apenas na pasta module/
if [ -d "module" ]; then
    echo "Executando Trivy security scan em: module/"
    
    # Scan de configuração (misconfigurations)
    echo "=== Trivy Config Scan ==="
    trivy config module/ --format table
    
    # Scan de filesystem (vulnerabilidades em dependências)
    echo "=== Trivy Filesystem Scan ==="
    trivy fs module/ --format table --security-checks vuln
    
    echo "Trivy scan concluído!"
else
    echo "Pasta module/ não encontrada"
fi
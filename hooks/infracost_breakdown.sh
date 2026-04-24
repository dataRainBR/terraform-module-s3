#!/bin/bash

set -e

# Função para verificar se infracost está instalado
check_infracost() {
    if command -v infracost &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Função para instalar infracost
install_infracost() {
    echo "Infracost não encontrado. Instalando..."
    
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
    
    # Versão do infracost
    VERSION="0.10.35"
    
    # URL de download
    URL="https://github.com/infracost/infracost/releases/download/v${VERSION}/infracost-${OS}-${ARCH}.tar.gz"
    
    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Baixar e extrair
    echo "Baixando Infracost ${VERSION} para ${OS}-${ARCH}..."
    curl -Lo infracost.tar.gz "$URL"
    tar -xzf infracost.tar.gz
    
    # Instalar no PATH
    if [ -w "/usr/local/bin" ]; then
        sudo mv infracost-${OS}-${ARCH} /usr/local/bin/infracost
    else
        # Fallback para diretório local
        mkdir -p "$HOME/.local/bin"
        mv infracost-${OS}-${ARCH} "$HOME/.local/bin/infracost"
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Limpar
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    echo "Infracost instalado com sucesso!"
}

# Verificar se infracost está instalado
if ! check_infracost; then
    install_infracost
fi

# Executar infracost breakdown apenas na pasta module/
if [ -d "module" ]; then
    echo "Executando Infracost breakdown em: module/"
    cd module
    
    # Verificar se há API key configurada
    if [ -z "$INFRACOST_API_KEY" ]; then
        echo "Aviso: INFRACOST_API_KEY não configurada. Usando modo offline limitado."
        echo "Para funcionalidade completa, configure: export INFRACOST_API_KEY=your_key"
        echo "Obtenha sua chave gratuita em: https://www.infracost.io/docs/#quick-start"
    fi
    
    # Executar breakdown
    echo "=== Infracost Breakdown ==="
    if infracost breakdown --path . --format table 2>/dev/null; then
        echo "Infracost breakdown concluído!"
    else
        echo "Aviso: Falha no Infracost breakdown. Possíveis causas:"
        echo "- API key não configurada ou inválida"
        echo "- Recursos não suportados pelo Infracost"
        echo "- Problemas de conectividade"
    fi
    
    cd - > /dev/null
else
    echo "Pasta module/ não encontrada"
fi
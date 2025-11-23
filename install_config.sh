#!/bin/bash

# Nome do diretório de configuração do NeoVim
CONFIG_DIR="nvim"

# Caminho de destino da configuração (geralmente ~/.config/nvim)
DEST_PATH="$HOME/.config/$CONFIG_DIR"

# Diretório de origem (onde este script está sendo executado)
SOURCE_PATH="$(dirname "$(readlink -f "$0")")"

echo "--- Script de Instalação da Configuração do NeoVim ---"

# 1. Backup da configuração existente (se houver)
if [ -d "$DEST_PATH" ]; then
    echo "Configuração existente encontrada em $DEST_PATH."
    BACKUP_PATH="${DEST_PATH}_backup_$(date +%Y%m%d%H%M%S)"
    echo "Criando backup em $BACKUP_PATH"
    mv "$DEST_PATH" "$BACKUP_PATH"
    if [ $? -ne 0 ]; then
        echo "ERRO: Falha ao criar backup. Abortando."
        exit 1
    fi
fi

# 2. Criação do link simbólico
echo "Criando link simbólico de $SOURCE_PATH para $DEST_PATH"
ln -s "$SOURCE_PATH" "$DEST_PATH"

if [ $? -ne 0 ]; then
    echo "ERRO: Falha ao criar o link simbólico. Abortando."
    exit 1
fi

echo "Sucesso! A nova configuração do NeoVim foi instalada."
echo "Você pode iniciar o NeoVim com 'nvim' e ele deve começar a instalar os plugins."
echo "--- FIM ---"

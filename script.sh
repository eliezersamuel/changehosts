#!/bin/bash
# script.sh
# Versao: 0.0.1
# Script para: Troca do /etc/hosts
# 2024-07-03 13:51-0300
# Codificacao utf-8
# Autor: Eliezer Samuel

# Testa se tem o dialog, senão instala em background
[ ! -x "$(which dialog)" ] && sudo apt install dialog 1> /dev/null 2>&1

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root ou use sudo."
    exit 1
fi

# Função para copiar o arquivo selecionado para /etc/hosts
trocar_hosts() {
    local arquivo=$1
    sudo cp "./hosts/$arquivo" /etc/hosts
    if [ $? -eq 0 ]; then
        echo "Arquivo /etc/hosts substituído com sucesso."
    else
        echo "Erro ao substituir o arquivo /etc/hosts."
        exit 1
    fi
}

# Verifica se passou argumentos e se não apresenta um dialog para escolher o host especifico
if [ "$#" -ge 1 ]; then
    result=$1
    if [ -e "./hosts/$result" ]; then
        echo "Você selecionou: $result"
    else
        echo "Erro: O arquivo '$result' não existe no diretório ./hosts/"
        exit 1
    fi
else
    # Listar arquivos no diretório ./hosts/
    HOSTS=$(ls ./hosts/)

    # Verifica se encontrou arquivos no diretório ./hosts/
    if [ -z "$HOSTS" ]; then
        dialog --title "Erro" --msgbox "Nenhum arquivo encontrado no diretório ./hosts/" 0 0
        exit 1
    fi

    # Cria a lista de opções para o radiolist
    OPTIONS=()
    for FILE in $HOSTS; do
        OPTIONS+=("$FILE" "$FILE" off)
    done

    # Mostra o radiolist para o usuário selecionar
    result=$(dialog --title "Seleção de arquivo" --radiolist "Selecione um arquivo:" 0 0 0 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

    # Limpa a tela
    clear
    # Exibe o resultado
    dialog --title 'Finalmente!' --msgbox "Você selecionou: $result" 0 0
fi

# Chama a função para copiar o arquivo selecionado
trocar_hosts "$result"
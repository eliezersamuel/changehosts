#!/bin/bash
# script.sh
# Versao: 0.1.0
# Script para: Troca do /etc/hosts
# 2024-07-03 13:51-0300
# Codificacao utf-8
# Autor: Eliezer Samuel

# Testa se tem o dialog, senão instala em background
[ ! -x "$(which dialog)" ] && sudo apt install dialog -y 1> /dev/null 2>&1

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute este script como root ou use sudo."
    exit 1
fi

# Verifica o local "pwd" onde está o script
LOCAL=$(dirname "$(readlink -f "$0")")

# Verifica se tem o bd.txt
if [ -e "$LOCAL/bd.txt" ]; then
    BD=$(cat "$LOCAL/bd.txt")
fi

# Função para copiar o arquivo selecionado para /etc/hosts
trocar_hosts() {
    local arquivo=$1
    sudo cp "$LOCAL/hosts/$arquivo" /etc/hosts
    if [ $? -eq 0 ]; then
        echo "Arquivo /etc/hosts substituído com sucesso."
        if [ -e "$LOCAL/bd.txt" ]; then
            echo $arquivo > $LOCAL/bd.txt;
        fi
    else
        echo "Erro ao substituir o arquivo /etc/hosts."
        exit 1
    fi
}

# Listar arquivos no diretório ./hosts/
HOSTS=$(ls $LOCAL/hosts/)

# Verifica se encontrou arquivos no diretório ./hosts/
if [ -z "$HOSTS" ]; then
    dialog --title "Erro" --msgbox "Nenhum arquivo encontrado no diretório ./hosts/" 0 0
    exit 1
fi

# Cria a lista de opções para o radiolist
OPTIONSLIST=()
for FILE in $HOSTS; do
    OPTIONSLIST+=("$FILE")
done

# Cria a lista de opções para o radiolist
OPTIONS=()
for FILE in $HOSTS; do
    OPTIONS+=("$FILE" "" off)
done

# Verifica se passou argumentos e se não apresenta um dialog para escolher o host especifico
if [ "$#" -ge 1 ]; then
    result=$1
    if [ "$(echo "$result" | tr '[:upper:]' '[:lower:]')" = "help" ]; then
        echo "Escolha uma das opcoes abaixo:"
        for i in "${OPTIONSLIST[@]}"; do
            tput bold;
            if [ -n "$BD" ]; then
                if [ "$i" = "$BD" ]; then
                    tput setaf 2;  # Green text color
                    echo "* $i"
                else
                    tput setaf 1;  # Red text color
                    echo "- $i"
                fi
            else
                tput setaf 4;  # Blue text color
                echo "- $i"
            fi
            tput sgr0;  # Reset text color
        done
        exit 1
    fi

    if [ -e "$LOCAL/hosts/$result" ]; then
        echo "Você selecionou: $result"
    else
        echo "Erro: O arquivo '$result' não existe no diretório ./hosts/"
        exit 1
    fi
else
    # Mostra o radiolist para o usuário selecionar
    result=$(dialog --title "Seleção de arquivo" --radiolist "Selecione um arquivo:" 0 0 0 \
    "${OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

    # Limpa a tela
    clear

    if [ -n "$result" ]; then
    # Exibe o resultado
    dialog --title 'Finalmente!' --msgbox "Você selecionou: $result" 0 0
    fi
fi

# Chama a função para copiar o arquivo selecionado
if [ -n "$result" ]; then
    trocar_hosts "$result"
else    
    exit 1
fi
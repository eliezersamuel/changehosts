# CHANGE HOSTS
<strong>Versão: 0.0.1</strong>

Script para troca do arquivo /etc/hosts

## Descrição
Este script automatiza a substituição do arquivo /etc/hosts do sistema. Ele permite que o usuário selecione um arquivo de um diretório específico (./hosts/) para substituir o arquivo /etc/hosts.

## Requisitos
<strong>dialog:</strong> O script verifica se o utilitário dialog está instalado e, se não estiver, tenta instalá-lo.
<strong>Permissões de root:</strong> O script deve ser executado com privilégios de root.
<strong>Como usar: </strong>Certifique-se de que você tem permissões de root.

Coloque os arquivos de configuração de hosts que deseja usar no diretório ./hosts/.

Execute o script:

```bash
sudo ./script.sh
#Ou especifique diretamente o arquivo de hosts a ser usado:
sudo ./script.sh nome_do_arquivo_de_hosts
```

## Funcionalidades
Verifica se o dialog está instalado e tenta instalá-lo se necessário.
Verifica se o script está sendo executado com permissões de root.
Se um argumento é passado, verifica se o arquivo correspondente existe no diretório ./hosts/.
Se nenhum argumento é passado, exibe uma lista de arquivos no diretório ./hosts/ para o usuário selecionar.
Substitui o arquivo /etc/hosts pelo arquivo selecionado.

## Autor
Eliezer Samuel

## Histórico de versões
<strong>0.0.1 - 2024-07-03</strong>
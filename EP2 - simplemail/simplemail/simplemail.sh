#!/bin/bash

# createuser OK
# password   G
# login      OK
# listusers  OK
# msg        G
# list       G
# read       OK
# unread     OK
# delete     OK
# quit       OK

# CONVENÇÕES:
# 1) Nome dos métodos são da forma m_nomefuncao
# 2) N

# Função que checa se está correta a quantidade de argumentos passados para um dado comando
# ENTRADA) $1: Número de argumentos desejado
#          $2: Número de argumentos recebido
# SAÍDA)   1 (Deve-se bloquear a execução da função), ou 0 (Não se deve bloquear).
function checar_n_args {
    let N_ARGS=$2-1
    if [ $1 != "$N_ARGS" ]; then
        echo "Número de argumentos inválido: esperava-se $1; mas recebeu-se $2"
    else
        echo 0
    fi
}

# Função que cria os diretórios e os arquivos necessários para o programa "simplemail" funcionar
# São inexistentes tanto a ENTRADA quanto a SAÍDA dessa função.
function configuracao_inicial {
    mkdir -p Contas
    mkdir -p Mensagens

    if [ ! -e "Contas/Usuarios.usr" ]; then
        : > Contas/Usuarios.usr
    fi
    
    if [ ! -e "Contas/Senhas.pssw" ]; then
        : > Contas/Senhas.pssw
    fi
}

# Função que cria um usuário, de modo que se imprime um erro caso o usuário já exista
# ENTRADA) $1: Nome do usuário o qual se deseja criar
#          $2: Senha a qual se atrelará com um dado usuário               
# SAÍDA) Nenhuma variável, somente uma mensagem de erro caso o usuário já exista.
function criar_usuario {
    BLOQUEIO=`checar_n_args 2 ${#@}`
    if [ "$BLOQUEIO" = "0" ]; then
        if [ -z $(grep '$2' Contas/Usuarios.usr) ]; then
            echo "$2" >> Contas/Usuarios.usr
            echo "$3" >> Contas/Senhas.pssw
            mkdir Mensagens/$2
        else
            echo "O usuário $2 já existe."
        fi    
    fi
}

# Função que faz o login do usuário.
# ENTRADA) $2: nome do usuário, $3: senha do usuário.
# SAÍDA) Caso haja alguma inconsistência, retorna-se uma mensagem de erro. 
#        Senão, a função não retorna nada.
function entrar {
    BUSCA_USUARIO=$(grep -n $2 ./Contas/Usuarios.usr | cut -d ":" -f 1)
    if [ -z BUSCA_USUARIO ]; then
        echo "Usuário inválido. Por favor, tente novamente."
    else
        BUSCA_SENHA=$(sed "${BUSCA}q;d" ./Contas/Senhas.pssw) 
        if [ $3 = $BUSCA_SENHA ]; then
           USUARIO=$2 # login concluído com sucesso.
        else    
           echo "Usuário ou senha incorreto. Por favor, tente novamente."
        fi
    fi
}

function listar_usuarios {
    more Contas/Usuarios.usr
}

function listar_mensagens {
    if [ -z $USUARIO ]; then
        echo "É necessário fazer o login primeiro!"
    else 
        for mensagem in Mensagens/$USUARIO/ ; do
            echo mensagem | tr  '\n' '|' | sed -e  
            sed -e 's/' | echo
        done
    fi
    echo "Foi! :)"
}

# Função que mostra a mensagem cujo ID é o número passado como parâmetro na saída padrão.
# ENTRADA) $2: ID da mensagem a ser mostrada. 
# SAÍDA) Se o ID passado não for válido, retorna-se uma mensagem de erro.
function ler_mensagem {
    if [ -z $USUARIO ]; then
        echo "É necessário fazer o login primeiro!"
    else
        ID_VALIDO=false

        for numero_msg in $( ls ./Mensagens/$USUARIO); do
            if [ $2 = $numero_msg ]; then
                ID_VALIDO=true
            fi
        done

        NUMERO_LINHAS=$(wc -l ./Mensagens/$USUARIO/$2 | cut -c1)

        if $ID_VALIDO; then
            # Marcar como lida:
            sed -i '2s/.*/ /' Mensagens/$USUARIO/$2

            # Mostrar a mensagem:
            for i in `seq 5 $NUMERO_LINHAS`; do
                sed "${i}q;d" Mensagens/$USUARIO/$2
            done
            # Tentativas fracassadas:
            #sed "5,${NUMERO_LINHAS}p" Mensagens/$USUARIO/$2 #| echo
            #awk "NR >= 5 && NR <= $NUMERO_LINHAS" Mensagens/$USUARIO/$2 | echo
            #sed -n '5,33p' < file.txt
        else 
            echo "ID da mensagem é inválido. Tente outro."
        fi
    fi
}

# Função que marca como não lida a mensagem cujo ID é o número passado como parâmetro na saída padrão.
# ENTRADA) $2: ID da mensagem a ser marcada como não lida. 
# SAÍDA) Se o ID passado não for válido, retorna-se uma mensagem de erro.
function marcar_nao_lida {
    if [ -z $USUARIO ]; then
        echo "É necessário fazer o login primeiro!"
    else
        ID_VALIDO=false

        for numero_msg in $( ls ./Mensagens/$USUARIO); do
            if [ $2 = $numero_msg ]; then
                ID_VALIDO=true
            fi
        done

        if $ID_VALIDO; then
            sed -i '2s/.*/N/' Mensagens/$USUARIO/$2
        else 
            echo "ID da mensagem é inválido. Tente outro."
        fi
    fi
}

# Função que apaga a mensagem cujo ID é o número passado como parâmetro.
# ENTRADA) $2: ID da mensagem a ser apagada. 
# SAÍDA) Se o ID passado não for válido, retorna-se uma mensagem de erro.
function apagar_mensagem {
    
    if [ -z $USUARIO ]; then
        echo "É necessário fazer o login primeiro!"
    else
        ID_VALIDO=false

        for numero_msg in $( ls ./Mensagens/$USUARIO); do
            if [ $2 = $numero_msg ]; then
                ID_VALIDO=true
            fi
        done

        if $ID_VALIDO; then
            rm ./Mensagens/$USUARIO/$2
        else 
            echo "ID da mensagem é inválido. Tente outro."
        fi
    fi
}

# Não use CAT
# Não use TOUCH
# 

function main {
    configuracao_inicial
    
    while [ "$COMANDO" != "quit" ]; do
        read -p "simplemail> " COMANDO # COMANDO = (núcleo) (arg1) (arg2) ...
        
        NUCLEO=`echo $COMANDO | cut -d " " -f 1`
        case $NUCLEO in
            createuser) criar_usuario $COMANDO;;
            passwd) modificar_senha $COMANDO;;
            login) entrar $COMANDO;;
            listusers) listar_usuarios $COMANDO;;
            msg) enviar_mensagem $COMANDO;;
            list) listar_mensagens $COMANDO;;
            read) ler_mensagem $COMANDO;;
            unread) marcar_nao_lida $COMANDO;;
            delete) apagar_mensagem $COMANDO;;
        esac
    done
}

main
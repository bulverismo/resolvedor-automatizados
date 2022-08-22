#!/bin/bash

DEBUG="${1:-false}"
DEBUG_AGRESSIVO="${2:-false}"

"$DEBUG_AGRESSIVO" && {
    set -x 
}

if ! sshpass -v &>/dev/null
then
    echo Não tem sshpass && exit 1
fi

if ! ssh localhost :
then
    echo Não tem ssh client instalado && exit 2
fi

. utils.sh

# semeando...
echo bandit0 > senhas/0

qtd_arqs="$(ls senhas | wc -l)"
inicio="$(expr $qtd_arqs - 1)"

for fase in $(seq "$inicio" 34)
do
    echo "Fase atual = $fase"
    
    # Setup do laço atual
    test -a "senhas/$fase"    || { echo "Não há senha para a fase $fase"; exit 10;}
    test -a "solucoes/$fase" || { echo "Não há solução para a fase $fase"; exit 11;}

    proxima_fase="$(expr $fase + 1)"
    arquivo_da_senha="$fase"
    arquivo_da_senha_da_proxima_fase="senhas/$proxima_fase"
    solucao_atual="solucoes/$fase"
    senha_da_fase_atual="$(<senhas/$fase)"
    arquivo_temporario="$(mktemp)"
    comandos="$(cat solucoes/$fase)"

    "$DEBUG" && {
        echo "        ARQUIVO TEMPORARIO = $arquivo_temporario"
        echo "ARQUIVO DA SENHA DA FASE $fase = senhas/$arquivo_da_senha"
        echo "           SENHA DA FASE $fase = $senha_da_fase_atual"
    }

    echo -en "Passo a passo da solução da fase $fase:${COR_PROCESSO}\n\n"
    sed 's/^/\t/' "solucoes/$fase"
    echo ""

    echo -en "${REMOVE_COR}Executando a solução..."
    executador "$senha_da_fase_atual" "$fase" "$DEBUG" "$comandos" "$arquivo_temporario"
    echo -e "${COR_SUCESSO}Ok${REMOVE_COR}" # TODO: ver se da pra executar de fundo e então botar uma chave girando
    
    tmp_senha="$(tail -n1 $arquivo_temporario)"

    "$DEBUG" && {
        echo "Output gerado:"
        cat "$arquivo_temporario"
    }

    if [[ -a "solucoes/comandos_locais/$FASE" ]]
    then

        echo -n "Procedimento especial para garantir acesso sendo realizado..."
        ./solucoes/comandos_locais/$FASE
        echo -e "${COR_SUCESSO}Ok${REMOVE_COR}"

        echo "void" > "$arquivo_da_senha_da_proxima_fase"
        echo -e "${COR_SUCESSO}Acesso a fase $proxima_fase foi garantido através de um procedimento especial${REMOVE_COR}"

    else

        echo -en "\nTestando se a senha esta no padrão esperado..."
        [[ "$(wc -c <<< $tmp_senha)" == "34" ]] || { echo -e "${COR_SENHA}Número de characteres inválido, verificar solução${REMOVE_COR}" && exit 1 ; }

        for (( i=0; i<32; i++ ))
        do
            char_valido "${tmp_senha:$i:1}" || { echo -e "${COR_SENHA}Há characteres inválidos, verificar solução${REMOVE_COR}" && exit 2 ; }
        done

        executador "$tmp_senha" "$proxima_fase" "$DEBUG" "exit 0" "$arquivo_temporario" || { echo -e "${COR_SENHA}Não conseguiu conectar com a senha detectada, verificar solução${REMOVE_COR}" && exit 3 ; }

        echo -e "${COR_SUCESSO}Ok${REMOVE_COR}"

        echo -n "Salvando senha..."
        echo "$tmp_senha" > "$arquivo_da_senha_da_proxima_fase"
        echo -e "${COR_SUCESSO}Ok${REMOVE_COR}"

        echo -en "Senha capturada: ${COR_SENHA}"
        cat "$arquivo_da_senha_da_proxima_fase"
        echo -e "${REMOVE_COR}${COR_SEPARADOR}-------------------------------------------------${REMOVE_COR}"

    fi

done

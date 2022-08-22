COR_PROCESSO='\033[0;34m'  # azul
COR_SUCESSO='\033[0;33m'   # verde
COR_SENHA='\033[0;31m'     # vermelho
COR_SEPARADOR='\033[1;33m' # amarelo
REMOVE_COR='\033[0m'       # cor padrão 

executador() {

    [[ "$#" != "5" ]] && echo -e 'Difere do numero de argumentos necessário
    Uso:
    executador SENHA FASE DEBUG_FLAG COMANDOS ARQ_TMP

    exemplo:
    executador "bandit0" "0" "false" "$(cat solucoes/0)" "$(mktemp)"' && return 99

    SENHA="$1"
    FASE="$2"
    DEBUG_FLAG="$3"
    COMANDOS="$4"
    ARQ_TMP="$5"
    $DEBUG_FLAG && { echo -e "\n$ARQ_TMP\n";}
    ######################
    #---# Executador #---#
    sshpass -p "$SENHA"                                                         \
    ssh -tt -o StrictHostKeyChecking=no bandit$FASE@bandit.labs.overthewire.org \
        -p 2220                                                                 \
        "$DEBUG_FLAG && { set -x;};{ $COMANDOS; }"                              \
        > "$ARQ_TMP" \
        2>/dev/null
    ######################
}

executador_local() {

     [[ "$#" != "4" ]] && echo -e 'Difere do numero de argumentos necessário
    Uso:
    executador SENHA FASE DEBUG_FLAG ARQ_TMP

    exemplo:
    executador "bandit0" "0" "false" "$(mktemp)"' && return 99

    SENHA="$1"
    FASE="$2"
    DEBUG_FLAG="$3"
    ARQ_TMP="$4"
    $DEBUG_FLAG && { echo -e "\n$ARQ_TMP\n";}
    ############################
    #---# Executador Local #---#
    chmod +x solucoes/comandos_locais/$FASE
    bash ./solucoes/comandos_locais/$FASE > "$ARQ_TMP" 2>/dev/null
    ############################
   
}

char_valido() {
    # verifica se é um char valido
    echo "$1" | grep -q "[a-z0-9A-Z]" || return 1
    return 0
}

comando_remoto() {
    sshpass -p $(cat senhas/$1) ssh -p 2220 bandit$1@bandit.labs.overthewire.org
}

##### Exemplo básico de uso:

A ideia básica aqui é que você entra pelo fluxo normal do site e então descobre o que tem que fazer e depois anota esse passo a passo em um script e desses arquivos deve conter apenas os comandos que serão executados na máquina remota, ou local, quando é local ficam entro da subpasta comandos_locais:

```
# Exemplos de comandos dentro de um arquivo de solução
cd $(mktemp -d)
pwd
ls
nome="teste1"
echo -e 'lalia\npulou' > "$nome"
cat teste1 | grep pulou 
cat readme || true
cd
cat readme
```

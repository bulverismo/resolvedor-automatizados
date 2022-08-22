#### Como rodar?

```
chmod +x ./gerson.sh
./gerson.sh
```

#### Esse programinha depende de:

Um cliente ssh que responda no comando ssh
sshpass para poder logar na máquina remota enviando a senha como argumento.

##### Um pouco de contexto

O primeiro nivel desse jogo você tem a senha, então ele fica hardcoded no nosso programa, a partir dai ele segue uma espécie de receita para conseguir avançar para cada nível seguinte. Essas receitas foram obtidas entrando em cada nível e então salvas nos arquivos dentro da pasta solucoes.

Veja que a pasta senhas não tem nada inicialmente e na sequência ele vai preenchendo a pasta com o resultado de cada passo.

Perceba também que em alguns níveis precisa executar comandos na sua maquina local, pois precisa salvar a chave obtida nas maquinas remotas localmente, além disso também salva uma entrada no seu arquivo de configurações do seu cliente ssh, para poder acessar mais facilmente as máquinas que usam essas chaves salvas.

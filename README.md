<h1>Sistema Gerenciador de Banco de Dados - Sybase 16 - 64 bits</h1><p>

>Antes de instalar o Gerenciador de Banco de Dados é importante verificar as versões homologadas. Segue tabela:<p>

|       Versões homologadas SQL Anywhere 16          |
|----------------------------------------------------|
| Kernel: 2.6.18 ao 2.6.32; glibc 2.5, 2.9 e 2.12    |
| Kernel: 3.2.0 ao 3.12.28; glibc 2.15, 2.17 e 2.19  |

>### Iniciando a instalação:
1. Dê permissão de execução com o comando abaixo:
<p># chmod +x Install_DS.sh</p>

2. Execute o arquivo Install_DS.sh com o comando abaixo:
<p># ./Install_DS.sh</p>

3. Veja abaixo a tela inicial, pressione o número 1 para iniciar a instalação. <p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_01.png "Tela inicial") 

4. Realizando o download do source.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_02.png)

5. Informe o local onde deseja instalar o seu banco. Pressionando [ ENTER ] será instalado na pasta /opt.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_03.png)

6. Informe o local do backup do seu banco de dados, a pasta deve conter os arquivos contabil.db e contabil.log.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_04.png)

7. Após informar o local pressione [ ENTER ], o seu banco será copiado e enviado para a pasta definida no item 5.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_05.png)

8. Informe a quantidade de memoŕia em MB que será alocada para o seu banco.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_06.png)

9. Informe o nome que identificará o seu banco iniciado na rede.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_07.png)

10. Informe a distribuição ou derivadas de outras.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_08.png)

11. Escolha a opção 1 para inciar o banco de imediato.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_09.png)

12. Obsverve a mensagem informando que o banco de dados "srvlinux", nome inserido no item 9, foi iniciado com sucesso.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_10.png)

13. Ecolha o número 2 para não iniciar outro banco e pressinando [ ENTER ] para voltar ao menu principal.<p>
![alt text](https://opensourcesolution.com.br/sybase/instalacao/instalacao_img_11.png)<p>

>### Validação
> Não implemetado.

>### Desinstalação
> Ao realizar a desinstalação, automaticamente é iniciado o processo de pausa do banco, então é muito importante que todos os usuários estejam desconectados. Durante a desinstalação será realizado o backup da pasta Dados e enviada para uma pasta criada automaticamente chamada backup_dominio.<p>
![alt text](https://opensourcesolution.com.br/sybase/desinstalacao.png)<p>

>### Iniciar Banco de Dados
> Durante a instalação será questionado se deseja inciar o banco de dados. Caso tenha parado o banco utilizando o script, pode-se iniciar novamente escolhendo a opção 4 no menu principal.

>### Parar o Banco de dados
> Pode-se parar o banco de dados, escolhendo a opção 5 no menu principal.

>### Realizar backup
> Opção 6. Ao realizar um backup do banco de dados o banco de dados será parado e iniciado o processo de backup para a pasta padrão $home/backup_dominio<p>
![alt text](https://opensourcesolution.com.br/sybase/backup.png)<p>

>### Inserir Licença
> Entre em contato com o suporte http://www.dominiosistemas.com.br/unidades

>### Ajuda
> Algumas informações para auxílio.

>### Sair
> Opção 9 do menu principal, permite a saída do script.

#!/bin/bash
# Versão: Beta 1.0.0
# Nome: Install_DS.sh
# Descrição: Instala o gerenciador de banco de dados Sybase 16 - 64 bits
# Escrito por: Jackson de Oliveira ( Campinas - São Paulo)
# E-mail: mr.jkolive@gmail.com
# Versões testadas: Debian 7 e 8, CentOS 6 e 7, Ubuntu 12.04 e 14.04, Mint 19 Cinnamon

versao='Beta 1.0.0'

versaoSistema(){

dpkg --help > /dev/null 2>&1  # Comando teste

if [ $? -eq 0 ] ; then
	tput setaf 1	
	echo '  ----------------------------------------------------'
        echo ' |       Versões homologadas SQL Anywhere 16          |'
        echo ' |----------------------------------------------------|'
        echo ' | Kernel: 2.6.18 ao 2.6.32; glibc 2.5, 2.9 e 2.12    |'
        echo ' | Kernel: 3.2.0 ao 3.12.28; glibc 2.15, 2.17 e 2.19  |'
        echo '  ----------------------------------------------------'
        echo

	glibc=`ldd --version | grep GLIBC`
	echo "::: Versões instaladas em seu sistema :::"
	echo "glibc - $glibc"
	kernel=`uname -r | cut -c 1-6`
	echo "Kernel - $kernel"
	echo 
	tput sgr0

elif [ glibc=`rpm -q glibc | cut -c 7-10` ] ; then
 	tput setaf 1
	echo '  ----------------------------------------------------'
        echo ' |       Versões homologadas SQL Anywhere 16          |'
        echo ' |----------------------------------------------------|'
        echo ' | Kernel: 2.6.18 ao 2.6.32; glibc 2.5, 2.9 e 2.12    |'
        echo ' | Kernel: 3.2.0 ao 3.12.28; glibc 2.15, 2.17 e 2.19  |'
        echo '  ----------------------------------------------------'
        echo 

	glibc=`rpm -q glibc | cut -c 7-10`
	echo "::: Versões instaladas em seu sistema :::"
	echo "glibc - $glibc"
	kernel=`uname -r | cut -c 1-6`
	echo "Kernel - $kernel"
	tput sgr0
else 
	tput setaf 7
	echo 'Não foi possivel obter a versão do kernel e da biblioteca glibc'
	tput sgr0
fi

}

Instalacao(){

unset srvnome
unset local_inst
unset dir_back
unset half_memory

if [ -d /opt/sybase ] ; then
	tput setaf 7
	echo 'Gerenciador já instalado!'
	tput sgr0
	sleep 1
	Menu # Função
elif [ -d /opt/ ] ; then
	mkdir -p /opt/sybase
	versaoSistema # Função
	tput setaf 7
	echo 'Iniciando instalação...'
	echo 'Instalando o Gerenciador Sybase...'
	tput sgr0
	sleep 3
	clear
	yum install wget -y > /dev/null 2>&1
	yum install psmisc -y > /dev/null 2>&1
if [ -f /tmp/ASA-1600-2747-Linux-64.tar.gz ] ; then
	tar -xvf /tmp/ASA-1600-2747-Linux-64.tar.gz -C /opt/sybase --strip-components=1 > /dev/null 2>&1
	chmod +x -R /opt/sybase 
	touch /opt/sybase/instalacao.txt
	rm /opt/sybase/bin64/setenv
       	echo 'SYBHOME="/opt/sybase"' >> /opt/sybase/bin64/setenv
	echo 'PATH="$PATH:$SYBHOME/bin64"' >> /opt/sybase/bin64/setenv
	echo 'LD_LIBRARY_PATH="$SYBHOME/lib64"' >> /opt/sybase/bin64/setenv
	echo 'export PATH LD_LIBRARY_PATH' >> /opt/sybase/bin64/setenv	
elif `wget -c -P /opt http://download.dominiosistemas.com.br/instalacao/diversos/sybase16_linux_64/ASA-1600-2747-Linux-64.tar.gz` ; then
	tar -xvf /opt/ASA-1600-2747-Linux-64.tar.gz -C /opt/sybase --strip-components=1 > /dev/null 2>&1
	chmod +x -R /opt/sybase
	touch /opt/sybase/instalacao.txt
	rm /opt/sybase/bin64/setenv
        echo 'SYBHOME="/opt/sybase"' >> /opt/sybase/bin64/setenv
        echo 'PATH="$PATH:$SYBHOME/bin64"' >> /opt/sybase/bin64/setenv
        echo 'LD_LIBRARY_PATH="$SYBHOME/lib64"' >> /opt/sybase/bin64/setenv
        echo 'export PATH LD_LIBRARY_PATH' >> /opt/sybase/bin64/setenv
	mv /opt/ASA-1600-2747-Linux-64.tar.gz /tmp > /dev/null 2>&1
else
	clear
	tput setaf 7
	echo 'Por favor verifique sua conexão de internet!'
	tput sgr0
	echo
	tput setaf 2
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	Menu # Função
	
	fi
else
	mkdir /opt
	Menu # Função
fi
	touch /etc/profile.d/domsis.sh
	chmod +x /etc/profile.d/domsis.sh
	echo '#!/bin/bash' >> /etc/profile.d/domsis.sh
	echo 'PATH="$PATH:/opt/sybase/bin64"' >> /etc/profile.d/domsis.sh
	echo 'LD_LIBRARY_PATH="/opt/sybase/lib64"' >> /etc/profile.d/domsis.sh
	echo 'export PATH LD_LIBRARY_PATH' >> /etc/profile.d/domsis.sh
	export PATH="$PATH:/opt/sybase/bin64"

while [ ! -d "$local_inst" ]
	do
		clear
		Head # Função
		tput setaf 1
		echo 'Informe o local para a instalação do banco de dados sem a barra no final: [ /opt ]'
		tput sgr0
		read local_inst
		if [ -z "$local_inst" ] ; then
			local_inst='/opt'
		fi
	if [ -d "$local_inst" ] ; then
		clear
		mkdir -p $local_inst/contabil/dados/log
		echo "$local_inst" >> /opt/sybase/instalacao.txt
		chmod +x /opt/sybase/bin64/setenv
	else
		tput setaf 7
		clear
		Head # Função
		echo 'Diretório não existe!, tente novamente'
		sleep 3
		tput sgr0
	fi
	done
while [ ! -d "$dir_back" ] || [[ ! ( -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ) ]] ;
	do
		clear
		Head # Função
		tput setaf 0
		echo '::: Importante ::: '
		echo '- Na pasta deve conter os arquivos com a extensão .db e .log;'
		tput sgr0
		tput setaf 1
		echo 'Informe o diretório onde encontra-se o backup do banco de dados, sem a barra no final. Ex: /home/usuario/Downloads'
		tput sgr0
		read dir_back
if [ ! -d "$dir_back" ] || [[ ! ( -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ) ]] ; then
		clear
		Head # Função
		tput setaf 7
		echo 'Diretório não existe ou arquivo de banco não encontrado...tente novamente!'
		tput sgr0
		sleep 1
	elif [ -d "$dir_back" ] && [[ -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ]] ; then
		tput setaf 7
		echo 'OK, efetuando cópia do banco de dados...Aguarde'
		tput sgr0
		cd $dir_back
		cp *.db *.log $local_inst/contabil/dados > /dev/null 2>&1
		cd $local_inst/contabil/dados > /dev/null 2>&1
		maiusculaMinuscula
		chmod +x $local_inst/contabil/dados/* > /dev/null 2>&1
	fi
	done
numero=1
while [ $numero != 0 ]
	do
		clear
		Head # Função
		tput setaf 1
		echo '-------------------------------------------'
		free -mh | grep -A 1 livre
		free -mh | grep -A 1 free
		echo '-------------------------------------------'
		echo 'Informe a quantidade de memória que será usada pelo banco. Acima é mostrada a quantidade de memória livre no sistema em MB:'
		tput sgr0
		read half_memory
	[ $half_memory -gt 0 ] 2> /dev/null
	if [ $? -eq 0 ] ; then
		numero=0
	else
		tput setaf 7
		echo 'Por favor, informe somente números!'
		tput sgr0
	fi
	done
while [ -z $srvnome ]
	do
		clear
		Head # Função
		tput setaf 1
		echo 'Informe o nome do servidor. Ex: srvlinux, srvcontabil'
		tput sgr0
		read srvnome
		echo "$srvnome" >> /opt/sybase/instalacao.txt
	if [ -z $srvnome ] ; then
		tput setaf 7
		echo 'Por favor informe o nome do servidor!'
		tput sgr0
	fi
	done
source /opt/sybase/bin64/setenv

escolhaDistrib # Função

iniciarBanco # Função


}

Validar(){
	# recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`" # Recupera local de instalação
	tput setaf 7
	echo 'Não implementado!'
	# echo 'Informe o nome de usuário com permissão para validação:'
	# read usuario
	# echo 'Informe a senha:'
	# read senha
	# dbvalid -c "UID=$usuario;PWD=$senha;DBF=$recup_local/contabil/dados/contabil.db" -fx
	tput sgr0
        echo 
	tput setaf 2
        read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
        Menu # Função

}

maiusculaMinuscula(){

ls *[A-Z]* | while read maiuscula
do
	minuscula=`echo $maiuscula | tr [A-Z] [a-z]`
	mv $maiuscula $minuscula > /dev/null 2>&1
done

}

escolhaDistrib(){

dist=0
while [ $dist == 0 ] ;
	do	
		clear
		Head # Função
		tput setaf 1
		echo 'Qual distribuição está sendo usada? informe o número:'
		echo '1 - Debian/Ubuntu/Mint'
		echo '2 - CentOS/Suse/Fedora'
		tput sgr0
		read dist
	  if [ -z "$dist" ] ; then
		dist=0
		clear
		Head # Função
		tput setaf 7
		echo "Por favor informe um valor!"
		sleep 2
		tput sgr0
	elif [ "$dist" -eq 1 ] ; then
		initDistribDEB # Função
	elif [ "$dist" -eq 2 ] ; then
		initDistribRPM # Função
	else
		dist=0
		clear
		Head # Função
		tput setaf 7
		echo 'Número inválido tente novamente!'
		sleep 2
		tput sgr0
	fi
	done

}

initDistribDEB() {

touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '### BEGIN INIT INFO' >> /etc/init.d/startDomsis.sh
echo '# Provides: SQL Anywhere' >> /etc/init.d/startDomsis.sh
echo '# Required-Start: $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Required-Stop:  $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Default-Start:  2 3 4 5' >> /etc/init.d/startDomsis.sh
echo '# Default-Stop:   0 1 6' >> /etc/init.d/startDomsis.sh
echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/startDomsis.sh
echo '# Description: Enable service provided by daemon.' >> /etc/init.d/startDomsis.sh
echo '### END INIT INFO' >> /etc/init.d/startDomsis.sh
echo 'source /opt/sybase/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'iptables -I INPUT -p tcp --dport 2638 -j ACCEPT' >> /etc/init.d/startDomsis.sh
echo 'iptables -D INPUT -p udp --dport 2638 -j ACCEPT > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'iptables -I INPUT -p udp --dport 2638 -j ACCEPT' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o '$local_inst'/contabil/dados/log/logservidor.txt '$local_inst'/contabil/dados/contabil.db' >> /etc/init.d/startDomsis.sh

# Comando para inicialização do sistema
update-rc.d startDomsis.sh defaults > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	clear
	tput setaf 7
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	tput sgr0
	rm /etc/init.d/startDomsis.sh
	sleep 2
	escolhaDistrib # Função
fi

}

initDistribRPM() {

touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '# chkconfig: 345 99 10' >> /etc/init.d/startDomsis.sh
echo '# description: Domsis' >> /etc/init.d/startDomsis.sh
echo 'source /opt/sybase/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --remove-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --remove-port=2638/udp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --add-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --add-port=2638/udp' >> /etc/init.d/startDomsis.sh
echo 'systemctl restart firewalld.service' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o '$local_inst'/contabil/dados/log/logservidor.txt '$local_inst'/contabil/dados/contabil.db' >> /etc/init.d/startDomsis.sh
cd /etc/init.d/
chkconfig --add startDomsis.sh > /dev/null 2>&1
chkconfig --level 235 startDomsis.sh on > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	clear
	tput setaf 7
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	tput sgr0
	rm /etc/init.d/startDomsis.sh
	sleep 2
	escolhaDistrib # Função
fi

}

Desinstalacao(){

if [ -d "/opt/sybase" ] ; then
	recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`"
	tput setaf 7
	echo 'Desinstalando o Gerenciador...'
	killall -w -s 15 dbsrv16 > /dev/null 2>&1
        tput setaf 7
        echo 'Parando o banco de dados....aguarde.'
        sleep 10
        echo "Banco encontrado!"
        echo "...efetuando o backup da pasta dados e enviando para a pasta $HOME/backup_dominio...Aguarde"
        tput sgr0
        mkdir -p $HOME/backup_dominio/Bancos > /dev/null 2>&1
        cp -R $recup_local/contabil/dados "$HOME/backup_dominio/Bancos/dados_$(date +"%d-%m-%Y_%s")" > /dev/null 2>&1
	cp -R $recup_local/contabil/dados2 "$HOME/backup_dominio/Bancos/dados_$(date +"%d-%m-%Y_%s")" > /dev/null 2>&1
	rm -fr $recup_local/contabil > /dev/null 2>&1
	rm -fr /opt/sybase > /dev/null 2>&1
	rm /etc/profile.d/domsis.sh > /dev/null 2>&1
	rm /etc/init.d/startDomsis.sh > /dev/null 2>&1
	echo 'Removendo regras no firewall...'
	sleep 1
	firewall-cmd --permanent --zone=public --remove-port=2638/tcp > /dev/null 2>&1
	firewall-cmd --permanent --zone=public --remove-port=2638/udp > /dev/null 2>&1
	iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1
        iptables -D INPUT -p udp --dport 2638 -j ACCEPT > /dev/null 2>&1
	echo 'Removendo inicialização automática...'
	sleep 1
	update-rc.d -f startDomsis.sh remove > /dev/null 2>&1
	echo 'Gerenciador desinstalado com sucesso!'
	tput sgr0
	echo
	tput setaf 2
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	Menu # Função
else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 1
	Menu # Função
fi

}

iniciarBanco(){

if [ -d "/opt/sybase" ] ; then
banco=`ps axu | grep dbsrv | grep -v grep`;
op=0
while [ $op == 0 ] ;
	tput setaf 1
	echo 'Deseja iniciar o banco de dados agora?'
	echo '1 - Sim , 2 - Não'
	tput sgr0
	read op
do
	if [ -z "$op" ] ; then
		op=0
                clear
                tput setaf 7
                echo "Por favor informe um valor!"
                sleep 2
                tput sgr0	
	elif [ "$op" -eq 1 ] ; then
		if [ "$banco" ] ; then
			op=0
			echo 'Banco de Dados já iniciado!'; novoBanco # Funcão
			echo
			tput setaf 2
			read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
			tput sgr0
			Menu # Função
		else
			/etc/init.d/startDomsis.sh
			tput setaf 7
			echo "Banco de Dados $srvnome iniciado com sucesso!" 
			tput sgr0
			echo
			novoBanco # Função
			tput setaf 2
			echo
			read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
			tput sgr0
			Menu # Função
		fi
	elif [ "$op" -eq 2 ] ; then
		tput setaf 7
		echo "Banco de dados não iniciado!"
		echo 
		tput sgr0
		tput setaf 2
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		tput sgr0
		Menu # Função
	else
                tput setaf 7
		op=0
                echo "Opção inválida!"
		sleep 2
                echo 
                tput sgr0
	fi
done	
else
	op=0
	tput setaf 7
        echo 'Gerenciador não instalado!'
        tput sgr0
	sleep 2
fi

}

novoBanco() {

### Iniciar outro banco ####

recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`"
srvnome="`awk 'NR>=2 && NR<=2' /opt/sybase/instalacao.txt`"

if [ ! -d $recup_local/contabil/dado2 ] ; then 

op=0
while [ $op != 1 ] ;
do
	tput setaf 1
	echo 'Deseja iniciar outro banco?'
	echo 'Escolha uma opção: 1 - Sim, 2 - Não'
	tput sgr0
	read op
if [ -z "$op" ] ; then
                op=0
                clear
                Head # Função
                tput setaf 7
                echo "Por favor informe um valor!"
                sleep 2
                tput sgr0
elif [ "$op" -eq 1 ] ; then
	while [ ! -d "$dir_novo_banco" ] || [[ ! ( -e "$dir_novo_banco/contabil.db" || -e "$dir_novo_banco/Contabil.db" ) ]] ;
	do
		clear
		Head # Função
		tput setaf 1
		echo 'Informe o local de backup do novo banco de dados que deseja iniciar. Ex.: /home'
		tput sgr0
		read dir_novo_banco
	if [ ! -d "$dir_novo_banco" ] || [[ ! ( -e "$dir_novo_banco/contabil.db" || -e "$dir_novo_banco/Contabil.db" ) ]] ; then
		clear
		Head # Função
		tput setaf 7
		echo 'Diretório não existe ou arquivo de banco não encontrado...tente novamente!'
		tput sgr0
		sleep 1
	elif [ -d "$dir_novo_banco" ] && [[ -e "$dir_novo_banco/contabil.db" || -e "$dir_novo_banco/Contabil.db" ]] ; then
		cd $dir_novo_banco
		maiusculaMinuscula # Função
		tput setaf 7
		echo "Copiando arquivos para a pasta padrão $local_inst/contabil/dados2"
		tput sgr0
		mkdir -p $local_inst/contabil/dados2/log > /dev/null 2>&1
		touch $local_inst/contabil/dados2/log/logservidor.txt
		cp $dir_novo_banco/* $local_inst/contabil/dados2 > /dev/null 2>&1
	fi
	done
		numero=1
		while [ $numero != 0 ]
		do
			clear
			Head # Função
			echo '-------------------------------------------'
			free -mh | grep -A 1 livre
			free -mh | grep -A 1 free
			tput setaf 1
			echo '-------------------------------------------'
			echo 'Informe a quantidade de memória que será usada pelo banco. Acima é mostrada a quantidade de memória livre no sistema em MB:'
			tput sgr0
			read half_memory
			[ $half_memory -gt 0 ] 2> /dev/null
		if [ $? -eq 0 ] ; then
			numero=0
		else	
			tput setaf 7
			echo 'Por favor, informe somente números!'
			tput sgr0
		fi
		done
                        while [ -z $srvnome2 ]
                        do
				clear
				Head # Função
				tput setaf 1
                                echo 'Informe o nome do servidor para o novo banco:'
                                tput sgr0
				read srvnome2
                        if [ -z $srvnome2 ] ; then
				clear
				Head # Função
				tput setaf 7
                                echo 'Nome de servidor vazio, por favor informe o nome do servidor.'
				tput sgr0
                        elif [ "$srvnome" = "$srvnome2" ] ; then
				clear
				Head # Função
                                unset srvnome2
				tput setaf 7
                                echo 'Nome do servidor já em uso, por favor informe outro nome.'
				sleep 3
				tput sgr0
                        else
				clear
				Head # Função
				echo "$srvnome2" >> /opt/sybase/instalacao.txt
                                source /opt/sybase/bin64/setenv
				tput setaf 7
				echo 'Aguarde...iniciando banco...'
				tput sgr0
                                echo 'dbsrv16 -c '$half_memory'M -n '$srvnome2' -ud -o '$local_inst'/contabil/dados2/log/logservidor.txt '$local_inst'/contabil/dados2/contabil.db' >> /etc/init.d/startDomsis.sh
                                dbsrv16 -c "$half_memory"M -n "$srvnome2" -ud -o "$local_inst"/contabil/dados2/log/logservidor.txt "$local_inst"/contabil/dados2/contabil.db
				tput setaf 7
                                echo "Banco de dados $srvnome2 iniciado com sucesso!"
                                tput sgr0
				echo
				tput setaf 2
                                read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
                                tput sgr0
				Menu # Função
                        fi
                        done
elif [ "$op" -eq 2 ] ; then
	tput setaf 2
	echo
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	Menu # Função
else
	clear
	tput setaf 7
	echo 'Opção inválida, tente novamente!'
	tput sgr0
fi
done

else
	echo 'O script somente instala dois bancos'
fi

}

pararBanco(){

if [ -d "/opt/sybase" ] ; then
	tput setaf 7
	echo 'Aguarde...'
	tput sgr0
	sleep 2
	killall -w -s 15 dbsrv16 > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
		tput setaf 7
		echo 'Banco de Dados parado com sucesso!'
		tput sgr0
		echo
		tput setaf 7
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		tput sgr0
		Menu # Função
	else
		tput setaf 7
		echo 'Banco de Dados não estava iniciado!'
		tput sgr0
		echo
		tput setaf 2
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		tput sgr0
		Menu # Função
	fi
else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 1
	Menu # Função
fi

}

realizarBackup(){

if [ -d "/opt/sybase" ] ; then
	recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`"
	killall -w -s TERM dbsrv16 > /dev/null 2>&1
	tput setaf 7
	echo 'Parando o banco de dados....aguarde.'
	sleep 10
	echo "Banco encontrado!"
	echo "...efetuando o backup da pasta dados e enviando para a pasta $HOME/backup_dominio...Aguarde"
	tput sgr0
	mkdir -p $HOME/backup_dominio/Bancos > /dev/null 2>&1
        cp -R $recup_local/contabil/dados "$HOME/backup_dominio/Bancos/dados_$(date +"%d-%m-%Y_%s")" > /dev/null 2>&1
        cp -R $recup_local/contabil/dados2 "$HOME/backup_dominio/Bancos/dados_$(date +"%d-%m-%Y_%s")" > /dev/null 2>&1
	tput setaf 7
	echo 'Cópia efetuada com sucesso!'
	tput sgr0
	tput setaf 2
	echo
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	Menu # Função
else
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 1
	Menu # Função
fi

}

inserirLicenca(){

if [ -d "/opt/sybase" ] ; then
	tput setaf 1
	echo 'Insira a quantide de licença contratada:'
	tput sgr0
	read quantLic
	tput setaf 1
	echo 'Insira o nome reduzido ou apelido da Empresa:'
	tput sgr0
	read apelidoEmpresa
	tput setaf 1
	echo 'Insira a razão social da empresa. Ex: Escritório Contabil ltda'
	tput sgr0
	read razaoSocial

	source /opt/sybase/bin64/setenv

	dblic -l perseat -u $quantLic /opt/sybase/bin64/dbsrv16.lic "$apelidoEmpresa" "$razaoSocial"
	echo
	tput setaf 2
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	tput sgr0
	Menu # Função
else	
	tput setaf 7
	echo 'Gerenciador não instalado!'
	tput sgr0
	sleep 1
	Menu # Função
fi

}

Ajuda(){

tput setaf 1
echo '### AJUDA ###' 
echo '- Para verificação da versao glibc no Ubuntu, execute o comando: ldd --version.'
echo '- Para verificação de versao glibc no Centos, execute o comando: rpm -q glibc.'
echo '- dbsrv16: Este é o nome do programa responsável pela inicialização do servidor de banco.'
tput sgr0
echo
tput setaf 2
read -p "Pressione [Enter] para voltar ao menu ou CTRL+C para sair..."
tput sgr0
Menu # Função

}

Head() {

tput setaf 1 

head="      #####################################################
      |               Bem-vindo ao instalador             |
      |            SQL Anywhere 16 - Linux 64 bits        |
      |                  Versão $versao                |
      #####################################################\n"

printf "$head"

tput sgr0

}

Menu() {

tput setaf 1

if [ "$(id -u)" != "0" ]; then
	echo 'Você deve executar este script como root!'
else
	clear
	Head # Função
#	echo "########################################################"
#	echo "|                Bem-vindo ao instalador               |"
#	echo "|            SQL Anywhere 16 - Linux 64 bits           |"
#	echo "|                  Versão $versao                   |"
#	echo "########################################################"
	tput setaf 1
	echo 'O que deseja realizar?'
	echo 'Digite:'
	tput sgr0
	tput setaf 2
	echo '1 - Instalar.'
	tput setaf 3
	echo '2 - Validar banco de dados.'
        tput setaf 2
	echo '3 - Desinstalar.'
	tput setaf 3
	echo '4 - Iniciar banco de dados.'
	tput setaf 2
	echo '5 - Parar o Banco de dados.'
	tput setaf 3
	echo '6 - Realizar um backup.'
	tput setaf 2 
	echo '7 - Inserir licença.'
	tput setaf 3
	echo '8 - Ajuda.'
	tput setaf 2
	echo '9 - Sair.'
	tput sgr0
	read var

case $var in
	1) Instalacao ;;
	2) Validar ;;
	3) Desinstalacao ;;
	4) iniciarBanco ;;
	5) pararBanco ;; 
	6) realizarBackup ;;
	7) inserirLicenca ;;
	8) Ajuda ;;
	9) tput setaf 7 ; echo 'Obrigado!'; tput sgr0 ; exit 0 ;;
	*) tput setaf 7; echo 'Opção inválida, tente novamente!'; tput sgr0 ; sleep 2 ; Menu # Função 
	esac
fi

}

## Funcão inicial ###
Menu 

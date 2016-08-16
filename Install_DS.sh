#!/bin/bash
# Versão: alpha 1.0.2
# Nome: Install_DS.sh
# Descrição: Instala o gerenciador de banco de dados Sybase 16 - 64 bits
# Escrito por: Jacksond de Oliveira ( Campinas - São Paulo)
# E-mail: mr.jkolive@gmail.com
# Versões testadas: Debian 7 e 8, CentOS 6 e 7, Ubuntu 14.04 

Instalacao(){

if [ -d /opt/sybase ] ; then
	echo 'Sistema já instalado!'
	sleep 1
	Menu
elif [ -d /opt/ ] ; then
	echo 'Iniciando instalação...'
	echo 'Instalando Domsis...'
	yum install wget -y > /dev/null 2>&1
	yum install psmisc -y > /dev/null 2>&1
if [ -f /tmp/ASA-1600-1691-Linux-64.tar.gz ] ; then
	tar -xvf /tmp/ASA-1600-1691-Linux-64.tar.gz -C /opt
elif `wget -c -P /opt http://download.domsis.com.br/instalacao/diversos/sybase16_linux_64/ASA-1600-1691-Linux-64.tar.gz` ; then
	tar -xvf /opt/ASA-1600-1691-Linux-64.tar.gz -C /opt
	mv /opt/ASA-1600-1691-Linux-64.tar.gz /tmp > /dev/null 2>&1
else
	tput setaf 3
	clear
	echo 'Por favor verifique sua conexão de internet!'
	exit 0
	fi
else
	mkdir /opt
	Menu
fi
	touch /etc/profile.d/domsis.sh
	chmod +x /etc/profile.d/domsis.sh
	echo '#!/bin/bash' >> /etc/profile.d/domsis.sh
	echo 'PATH="$PATH:/opt/sybase/SYBSsa16/bin64"' >> /etc/profile.d/domsis.sh
	echo 'LD_LIBRARY_PATH="/opt/sybase/SYBSsa16/lib64"' >> /etc/profile.d/domsis.sh
	echo 'export PATH LD_LIBRARY_PATH' >> /etc/profile.d/domsis.sh
	export PATH="$PATH:/opt/sybase/SYBSsa16/bin64"

while [ ! -d "$local_inst" ]
	do
		tput setaf 7
		echo 'Informe o local de instalação, sem a barra no final: Ex: /home'
		read local_inst
	if [ -d "$local_inst" ] ; then
		mkdir -p $local_inst/contabil/dados
		mkdir -p $local_inst/contabil/dados/log
		touch /opt/sybase/instalacao.txt
		echo "$local_inst" >> /opt/sybase/instalacao.txt
		chmod +x /opt/sybase/SYBSsa16/bin64/setenv
	else
		echo 'local não existe!, tente novamente'
	fi
	done
while [ ! -d "$dir_back" ] || [[ ! ( -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ) ]] ;
	do
		echo 'Informe o diretório onde se econtra o backup do banco de dados, sem a barra no final. Ex: /home/usuario/Downloads'
		read dir_back
if [ ! -d "$dir_back" ] || [[ ! ( -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ) ]] ; then
		clear
		echo 'Diretório não existe ou arquivo de banco não encontrado...tente novamente!'
		sleep 1
	elif [ -d "$dir_back" ] && [[ -e "$dir_back/contabil.db" || -e "$dir_back/Contabil.db" ]] ; then
		echo 'OK, efetuando cópia do banco de dados'
		cd $dir_back
		cp *.db *.log $local_inst/contabil/dados > /dev/null 2>&1
		cd $local_inst/contabil/dados > /dev/null 2>&1
		ls *[A-Z]* | while read maiuscula
			do
				minuscula=`echo $maiuscula | tr [A-Z] [a-z]`
				mv $maiuscula $minuscula > /dev/null 2>&1
			done
				chmod +x $local_inst/contabil/dados/* > /dev/null 2>&1
	fi
	done
numero=1
while [ $numero != 0 ]
	do
		echo '-------------------------------------------'
		free -mh | grep -A 1 livre
		free -mh | grep -A 1 free
		echo '-------------------------------------------'
		echo 'Informe metade da memória livre mostrada acima em MB, somente o número:'
		read half_memory
	[ $half_memory -gt 0 ] 2> /dev/null
	if [ $? -eq 0 ] ; then
		numero=0
	else
		echo 'Por favor, informe somente números!'
	fi
	done
while [ -z $srvnome ]
	do
		echo 'Informe o nome do servidor. Ex: srvlinux, srvcontabil'
		read srvnome
	if [ -z $srvnome ] ; then
		echo 'Por favor informe o nome do servidor!'
	fi
	done
source /opt/sybase/SYBSsa16/bin64/setenv

Escolha_Distrib

op=0
while [ $op != 1 ] && [ $op != 2 ] ;
	do
		echo 'Deseja iniciar o banco agora? [1-Sim, 2-Não]'
		read op
	if [ $op -eq 1 ] ; then
		sh /etc/init.d/startDomsis.sh
		echo 'Banco de Dados iniciado com sucesso!'
		unset local_inst
		unset dir_back
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	elif [ $op -eq 2 ] ; then
		echo 'Banco de Dados não iniciado!'
		unset local_inst
		unset dir_back								
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	fi
	done

}

Escolha_Distrib(){

dist=0
while [ $dist != 1 ] && [ $dist != 2 ] ;
	do
		echo 'Qual distribuição está sendo usada? informe o número:'
		echo '1 - Debian/Ubuntu/Ubuntu Server'
		echo '2 - CentOS/Suse/Fedora'
		read dist
	if [ "$dist" -eq 1 ] ; then
		Init_Distrib_DEB
	elif [ "$dist" -eq 2 ] ; then
		Init_Distrib_RPM
	else
		clear
		echo 'Número inválido tente novamente!'
	fi
	done

}

Init_Distrib_DEB() {

touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '### BEGIN INIT INFO' >> /etc/init.d/startDomsis.sh
echo '# Provides: Dominio Sistemas' >> /etc/init.d/startDomsis.sh
echo '# Required-Start: $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Required-Stop:  $remote_fs $syslog' >> /etc/init.d/startDomsis.sh
echo '# Default-Start:  2 3 4 5' >> /etc/init.d/startDomsis.sh
echo '# Default-Stop:   0 1 6' >> /etc/init.d/startDomsis.sh
echo '# Short-Description: Start daemon at boot time' >> /etc/init.d/startDomsis.sh
echo '# Description: Enable service provided by daemon.' >> /etc/init.d/startDomsis.sh
echo '### END INIT INFO' >> /etc/init.d/startDomsis.sh
echo 'source /opt/sybase/SYBSsa16/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'iptables -I INPUT -p tcp --dport 2638 -j ACCEPT' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o '$local_inst'/contabil/dados/log/logservidor.txt '$local_inst'/contabil/dados/contabil.db' >> /etc/init.d/startDomsis.sh

# Comando para inicilização do sistema
update-rc.d startDomsis.sh defaults > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	rm /etc/init.d/startDomsis.sh
	sleep 2
	Escolha_Distrib
fi

}

Init_Distrib_RPM() {

touch /etc/init.d/startDomsis.sh
chmod +x /etc/init.d/startDomsis.sh
echo '#!/bin/bash' >> /etc/init.d/startDomsis.sh
echo '# chkconfig: 345 99 10' >> /etc/init.d/startDomsis.sh
echo '# description: Domsis' >> /root/startDomsis.sh
echo 'source /opt/sybase/SYBSsa16/bin64/setenv > /dev/null 2>&1' >> /etc/init.d/startDomsis.sh
echo 'echo 'Liberando porta 2638 no firewall'' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --remove-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'firewall-cmd --permanent --zone=public --add-port=2638/tcp' >> /etc/init.d/startDomsis.sh
echo 'systemctl restart firewalld.service' >> /etc/init.d/startDomsis.sh
echo 'echo 'Iniciando o servidor...'' >> /etc/init.d/startDomsis.sh
echo 'dbsrv16 -c '$half_memory'M -n '$srvnome' -ud -o '$local_inst'/contabil/dados/log/logservidor.txt '$local_inst'/contabil/dados/contabil.db' >> /etc/init.d/startDomsis.sh
cd /etc/init.d/
chkconfig --add startDomsis.sh > /dev/null 2>&1
chkconfig --level 235 startDomsis.sh on > /dev/null 2>&1

if [ $? -eq 127 ] ; then
	echo 'A escolha da distribuição não é a correta, tente novamente!'
	rm /etc/init.d/startDomsis.sh
	sleep 2
	Escolha_Distrib
fi

}

Desinstalacao(){

if [ -d "/opt/sybase" ] ; then
	recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`"
	echo 'Desinstalando Domsis..'
	killall -w -s 15 dbsrv16 > /dev/null 2>&1
	echo "Efetuando um backup do banco de dados e enviando para a pasta $HOME/backup_dominio."
	sleep 1
	cp -R $recup_local/contabil/dados $HOME/backup_dominio > /dev/null 2>&1
	rm -fr $recup_local/contabil > /dev/null 2>&1
	rm -fr /opt/sybase > /dev/null 2>&1
	rm /opt/instalacao.txt > /dev/null 2>&1
	rm /etc/profile.d/domsis.sh > /dev/null 2>&1
	rm /etc/init.d/startDomsis.sh > /dev/null 2>&1
	echo 'Removendo regra no firewall...'
	sleep 1
	iptables -D INPUT -p tcp --dport 2638 -j ACCEPT > /dev/null 2>&1
	echo 'Removendo inicialização automático...'
	sleep 1
	update-rc.d -f startDomsis.sh remove > /dev/null 2>&1
	echo 'Domsis desinstalado com sucesso!'
	tput setaf 2
	echo ''
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	Menu
else
	echo 'Domsis não instalado!'
	sleep 1
	Menu
fi

}

IniciarBanco(){

if [ -d "/opt/sybase" ] ; then
	banco=`ps axu | grep dbsrv | grep -v grep`;
	if [ "$banco" ] ; then
		echo 'Banco de Dados já iniciado!'
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	else
		/etc/init.d/startDomsis.sh
		echo 'Banco de Dados iniciado com sucesso!'
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	fi
else
	echo 'Sistema não instalado!'
	sleep 1
	Menu
fi

}

PararBanco(){

if [ -d "/opt/sybase" ] ; then
	echo 'Aguarde...'
	sleep 2
	killall -w -s 15 dbsrv16 > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
		echo 'Banco de Dados parado com sucesso!'
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	else
		echo 'Banco de Dados não estava iniciado!'
		tput setaf 2
		echo ''
		read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
		Menu
	fi
else
	echo 'Sistema não instalado!'
	sleep 1
	Menu
fi

}

RealizarBackup(){

if [ -d "/opt/sybase" ] ; then
	recup_local="`awk 'NR>=0 && NR<=1' /opt/sybase/instalacao.txt`"
	killall -w -s TERM dbsrv16 > /dev/null 2>&1
	echo 'Parando o banco de dados....aguarde.'
	sleep 10
	echo "OK, efetuando backup do banco de dados e enviado para a pasta $HOME/backup_dominio...Aguarde"
	mkdir -p $HOME/backup_dominio
	cd $recup_local/contabil/dados
	cp *.db *.log $HOME/backup_dominio > /dev/null 2>&1
	ls *[A-Z]* | while read maiuscula
		do
			minuscula=`echo $maiuscula | tr [A-Z] [a-z]`
			mv $maiuscula $minuscula > /dev/null 2>&1
		done
			tput setaf 2
			echo 'Cópia efetuada com sucesso!'
			echo ''
			read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
			Menu
else
	echo 'Sistema não instalado!'
	sleep 1
	Menu
fi

}

InserirLicenca(){

if [ -d "/opt/sybase" ] ; then
	echo 'Insira a quantide de licença contratada:'
	read quantLic
	echo 'Insira o nome reduzido ou apelido da Empresa:'
	read apelidoEmpresa
	echo 'Insira a razão social da empresa. Ex: Escritório Contabil ltda'
	read razaoSocial

	source /opt/sybase/SYBSsa16/bin64/setenv

	dblic -l perseat -u $quantLic /opt/sybase/SYBSsa16/bin64/dbsrv16.lic "$apelidoEmpresa" "$razaoSocial"
	tput setaf 2			
	echo ''
	read -p 'Pressione [Enter] para voltar ao menu ou CTRL+C para sair...'
	Menu
else
	echo 'Sistema não instalado!'
	sleep 1
	Menu
fi

}

Ajuda(){

echo '### AJUDA ###' 
echo '- Para verificação da versao glibc no Ubuntu, execute o comando: ldd --version.'
echo '- Para verificação de versao glibc no Centos, execute o comando: rpm -q glibc.'
echo '- dbsrv16: Este é o nome do programa responsável pela inicialização do servidor de banco.'
echo ''
tput setaf 2
read -p "Pressione [Enter] para voltar ao menu ou CTRL+C para sair..."
Menu

}

Menu() {
if [ "$(id -u)" != "0" ]; then
	echo 'Você deve executar este script como root!'
else
	clear
	echo '########################################################'
	echo '|                Bem-vindo ao instalador               |'
	echo '| SQL Anywhere 16 - (Domínio Sistemas) - Linux 64 bits |'
	echo '|                   Versão alpha 1.0.2                 |'
	echo '########################################################'
	echo 'O que deseja realizar?'
	echo 'Digite:'
	tput setaf 2
	echo '1 - Instalar.'
	tput setaf 3
	echo '2 - Desinstalar.'
	tput setaf 2
	echo '3 - Iniciar banco de dados.'
	tput setaf 3
	echo '4 - Parar o Banco de dados.'
	tput setaf 2
	echo '5 - Realizar um backup.'
	tput setaf 3 
	echo '6 - Inserir licença.'
	tput setaf 2
	echo '7 - Ajuda.'
	tput setaf 3
	echo '8 - Sair.'
	read var
	tput setaf 6

case $var in
	1)
	Instalacao
	;;
	2)
	Desinstalacao
	;;
	3)
	IniciarBanco
	;;
	4)
	PararBanco
	;; 
	5)
	RealizarBackup
	;;
	6)
	InserirLicenca
	;;
	7)
	Ajuda
	;;
	8)
	echo 'Obrigado!'
	exit 0
	;;
	*)
	echo 'Opção inválida, tente novamente!'
	sleep 2
	Menu
	esac
fi

}

## Funcão inicial ###
Menu


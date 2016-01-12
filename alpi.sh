#!/bin/bash
##################################################
# Name: Arch Linux Pos Installation (alpi)
# Description: Pos Installation for Arch Linux
# Script Maintainer: ALT GNU/Linux
#
# Last Updated: 20/12/2015
##################################################
#
pacman -S --needed dialog --noconfirm

program(){

opcao=$(
      dialog --backtitle ' Arch Linux Pos Installation (alpi) - Version 0.0.5 Beta' \
	     --stdout               \
             --title 'Menu'  \
             --menu 'Selecione a opcao:' \
            0 0 0                   \
            1 'Instalacao base padrao (#ROOT)' \
	    2 'Instalacao completa padrao ($NO-ROOT)' \
	    6 'Reiniciar'	\
	    7 'Sobre'	\
            0 'Sair'                )

	opcao=$opcao

	[ $? -ne 0 ] && break

	if [ "$opcao" == "1" ]; then
	#Verifica se esta executando como ROOT
	checkRootUser() {

    	if [ "`whoami`" != "root" ];
      	then
	clear
        echo ""
        echo "--- :( ----------------------------------------------"
        echo ""
        echo "    Voce precisa ser root para continuar."
        echo ""
        exit 1
   	fi
	}

	#alias
	checkInstallUser() {
	checkRootUser
	}

	checkInstallUser
	#Verifica se esta executando como ROOT
	clear
	cd src
	sh install.sh
	cd ..
	
	program

	elif [ "$opcao" == "2" ]; then
	clear
	if [ "$(id -u)" == "0" ]; then
	echo ""
	echo "--- :( ----------------------------------------------"
	echo ""
	echo "    Voce nao pode continuar sendo root."
	echo ""
	exit 1
	fi
	cd src
	sh installyaourt.sh
	cd ..

	program

	elif [ "$opcao" == "6" ]; then
	reboot

	program

	elif [ "$opcao" == "7" ]; then
	dialog --title 'Sobre' --msgbox '\n
	\n
	########################################################################\n
	#                                                                      #\n
	#       ALT GNU/Linux - Arch Linux Pos Installation (alpi)             #\n
	#                                                                      #\n
	########################################################################\n	
	\n	
      	\n
	Arch Linux Pos Instalacao (alpi), e uma ferramenta que permite facilitar a
	configuracao do sistema Arch Linux apos a sua instalacao. Focada para iniciantes na 
	distribuicao e para usuarios experientes que querem automatizar a tarefa de
	configuracao do sistema.\n

      	\n
	Arch Linux Post installation (alpi), is a tool that allows you to facilitate the
	configuration of Arch Linux system after its installation. Focused to beginners in the 
	distribution and for experienced users who want to automate the task of system 
	configuration.\n
	\n
	\n
	\n
	\n
	\n
	                    Copyright (c) 2015 ALT GNU/Linux\n
	' 30 80

	program


else 
echo 'Saindo do programa...'
fi
}
program

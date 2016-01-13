#!/bin/bash
##################################################
# Name: Arch Linux Pos Installation (alpi)
# Description: Pos Installation for Arch Linux
# Script Maintainer: ALT Project
#
# Last Updated: 12/01/2016
##################################################
#
#Verificando se o pacman esta sendo usado por outro processo
FILE="/var/lib/pacman/db.lck"
if [ -e "$FILE" ] ; then
echo "-> Pacman esta sendo usado por outro processo.."
echo "-> Parando processo.."
rm /var/lib/pacman/db.lck
else
echo "-> [OK] Pacman nao esta sendo usado por nenhum processo.."
fi

pacman -Syu --noconfirm
pacman -S --needed dialog --noconfirm
#MULTIMIDIA
multimidia(){

multimidia=$(
      dialog --backtitle ' Arch Linux Pos Installation (alpi) - Version 0.6 Beta' \
	     --stdout               \
             --title 'Multimidia'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'VLC' \
	    2 'SMPlayer' \
	    3 'Rhythmbox' \
	    6 'Voltar' \
            0 'Sair'                )

	multimidia=$multimidia

	[ $? -ne 0 ] && break

	if [ "$multimidia" == "1" ]; then
	clear
	yaourt -S --needed vlc --noconfirm
	multimidia

	elif [ "$multimidia" == "2" ]; then
	clear
	yaourt -S --needed smplayer --noconfirm
	multimidia

	elif [ "$multimidia" == "3" ]; then
	clear
	yaourt -S --needed rhythmbox-git --noconfirm
	multimidia

	elif [ "$multimidia" == "6" ]; then
	clear
	programas
else 
echo 'Saindo do programa...'
fi
}
menu

#NAVEGADORES
navegadores(){

navegadores=$(
      dialog --backtitle ' Arch Linux Pos Installation (alpi) - Version 0.6 Beta' \
	     --stdout               \
             --title 'Navegadores'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'Mozilla Firefox' \
	    2 'Google Chrome' \
	    3 'Chromium' \
	    4 'Iceweasel' \
	    5 'Opera' \
	    6 'Voltar' \
            0 'Sair'                )

	navegadores=$navegadores

	[ $? -ne 0 ] && break

	if [ "$navegadores" == "1" ]; then
	clear
	yaourt -S --needed firefox firefox gst-libav gst-plugins-good upower --noconfirm
	navegadores

	elif [ "$navegadores" == "2" ]; then
	clear
	yaourt -S google-chrome --noconfirm
	navegadores

	elif [ "$navegadores" == "3" ]; then
	clear
	yaourt -S --needed chromium --noconfirm
	navegadores

	elif [ "$navegadores" == "4" ]; then
	clear
	yaourt -S --needed iceweasel --noconfirm
	navegadores

	elif [ "$navegadores" == "5" ]; then
	clear
	yaourt -S --needed opera --noconfirm
	navegadores

	elif [ "$navegadores" == "6" ]; then
	clear
	programas
else 
echo 'Saindo do programa...'
fi
}
menu

#PROGRAMAS
programas(){

programas=$(
      dialog --backtitle ' Arch Linux Pos Installation (alpi) - Version 0.6 Beta' \
	     --stdout               \
             --title 'Instalar Programas'  \
             --menu 'Selecione a categoria:' \
            0 0 0                   \
            1 'Navegadores' \
	    2 'Multimidia' \
	    3 'Desenvolvimento' \
	    9 'Voltar' \
            0 'Sair'                )

	programas=$programas

	[ $? -ne 0 ] && break

	if [ "$programas" == "1" ]; then
	navegadores

	elif [ "$programas" == "2" ]; then
	multimidia

	elif [ "$programas" == "3" ]; then
	desenvolvimento

	elif [ "$programas" == "9" ]; then
	menu
else 
echo 'Saindo do programa...'
fi
}
menu

menu(){

opcao=$(
      dialog --backtitle ' Arch Linux Pos Installation (alpi) - Version 0.6 Beta' \
	     --stdout               \
             --title 'Menu'  \
             --menu 'Selecione a opcao:' \
            0 0 0                   \
            1 'Instalacao padrao [PT-BR - GNOME] (#ROOT)' \
	    2 'Instalacao completa padrao ($NO-ROOT)' \
	    3 'Programas' \
	    4 'Reiniciar'	\
	    5 'Sobre'	\
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
	
	menu

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

	menu

	elif [ "$opcao" == "3" ]; then
	clear
	programas

	elif [ "$opcao" == "4" ]; then
	reboot

	menu

	elif [ "$opcao" == "5" ]; then
	dialog --title 'Sobre' --msgbox '\n
	\n
	########################################################################\n
	#                                                                      #\n
	#         ALT Project - Arch Linux Pos Installation (alpi)             #\n
	#                                                                      #\n
	########################################################################\n	
	\n	
      	\n
	Arch Linux Pos Instalacao (alpi), e uma ferramenta que permite facilitar a
	configuracao do sistema Arch Linux apos a sua instalacao. Focada para iniciantes
	na distribuicao e para usuarios experientes que querem automatizar a tarefa de
	configuracao do sistema.\n
	\n
	\n
	\n
	\n
	\n
	                    Copyright (c) 2016 ALT Project\n
	' 25 80

	menu


else 
echo 'Saindo do programa...'
fi
}
menu

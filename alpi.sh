#!/bin/bash
##################################################
# Name: Arch Linux Post Installation (alpi)
# Description: Pos Instalacao para Arch Linux
# Script Maintainer: ALT Project
#
##################################################
#
NAME="Arch Linux Post Installation (alpi)"
VERSION="0.8 Beta"
#Verificando se o pacman esta sendo usado por outro processo
clear
FILE="/var/lib/pacman/db.lck"
if [ -e "$FILE" ] ; then
echo "-> Pacman esta sendo usado por outro processo.."
echo "-> Parando processo.."
rm /var/lib/pacman/db.lck
else
echo "-> [OK] Pacman nao esta sendo usado por nenhum processo.."
fi

#Instalacao Yaourt
yaourtinstall(){
packagequery='https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz'
yaourt='https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz'

#Verifica se yaourt esta instalado
verify=$(which yaourt)
if [ "$verify" == "/usr/bin/yaourt" ] || [ "$verify" == "/usr/sbin/yaourt" ]; then
echo '-> [OK] Yaourt esta instalado...'
else
echo '-> Yaourt nao esta instalado. :('
echo '-> Instalando Yaourt...'
wget $packagequery $yaourt
tar -xvf package-query.tar.gz
tar -xvf yaourt.tar.gz
cd package-query
makepkg -sic --noconfirm
cd ..
cd yaourt
makepkg -sic --noconfirm
cd ..
rm -fR packa* yaour*
fi
}

#Verifica se esta executando como ROOT
root(){
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

#Verifica se nao e ROOT
noroot(){
if [ "$(id -u)" == "0" ]; then
clear
echo ""
echo "--- :( ----------------------------------------------"
echo ""
echo "    Voce nao pode continuar sendo root."
echo ""
exit 1
fi
}

echo "-> Iniciando aplicacao..."
echo "-> Verificando dependencias..."

#Verifica se e root para usar pacman
if [ "$(id -u)" == "0" ]; then
pacman -Sy --noconfirm
pacman -S --needed dialog wget --noconfirm
cd src
echo "-> Instalando Yaourt..."
pacman -U *.pkg.tar.xz --noconfirm
echo "-> Voce esta executando como root."
fi

#Verifica se nao e root para usar yaourt
if [ "`whoami`" != "root" ]; then
yaourtinstall
yaourt -Sy --noconfirm
yaourt -S --needed dialog --noconfirm
echo "-> Voce nao esta executando como root."
else
sudo pacman -S --needed wget dialog --noconfirm
yaourtinstall
yaourt -Sy --noconfirm
yaourt -S --needed dialog --noconfirm
fi

#PROGRAMAS
programas(){

programas=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Instalar Programas'  \
             --menu 'Selecione a categoria:' \
            0 0 0                   \
            1 'Internet' \
	    2 'Multimidia' \
	    3 'Desenvolvimento' \
	    4 'Aparencia e Personalizacao' \
	    5 'Imagem e Video' \
	    6 'Escritorio' \
	    7 'Virtualizacao e Containers' \
            8 'Outros' \
	    9 'Voltar' \
            0 'Sair'                )

	programas=$programas

	[ $? -ne 0 ] && return

	if [ "$programas" == "1" ]; then
	internet

	elif [ "$programas" == "2" ]; then
	multimidia

	elif [ "$programas" == "3" ]; then
	desenvolvimento

	elif [ "$programas" == "4" ]; then
	aparencia

	elif [ "$programas" == "5" ]; then
	imagemvideo

	elif [ "$programas" == "6" ]; then
	office

	elif [ "$programas" == "7" ]; then
	vm

	elif [ "$programas" == "8" ]; then
	outros

	elif [ "$programas" == "9" ]; then
	menu
else
echo 'Saindo do programa...'
fi
}
menu

#MULTIMIDIA
multimidia(){

multimidia=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Multimidia'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'VLC' \
	    2 'SMPlayer' \
	    3 'Rhythmbox' \
	    4 'Audacity' \
	    6 'Voltar' \
            0 'Sair'                )

	multimidia=$multimidia

	[ $? -ne 0 ] && return

	if [ "$multimidia" == "1" ]; then
	clear
	yaourt -S --needed vlc --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	multimidia

	elif [ "$multimidia" == "2" ]; then
	clear
	yaourt -S --needed smplayer --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	multimidia

	elif [ "$multimidia" == "3" ]; then
	clear
	yaourt -S --needed rhythmbox-git --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	multimidia

	elif [ "$multimidia" == "4" ]; then
	clear
	yaourt -S --needed audacity --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	multimidia

	elif [ "$multimidia" == "6" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#INTERNET
internet(){

internet=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Internet'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'Mozilla Firefox' \
	    2 'Google Chrome' \
	    3 'Chromium' \
	    4 'Iceweasel' \
	    5 'Opera' \
	    6 'Mozilla Thunderbird' \
	    7 'Voltar' \
            0 'Sair'                )

	[ $? -ne 0 ] && return

	if [ "$internet" == "1" ]; then
	clear
	yaourt -S --needed firefox firefox gst-libav gst-plugins-good upower --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "2" ]; then
	clear
	yaourt -S google-chrome --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "3" ]; then
	clear
	yaourt -S --needed chromium --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "4" ]; then
	clear
	yaourt -S --needed iceweasel --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "5" ]; then
	clear
	yaourt -S --needed opera --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "6" ]; then
	clear
	yaourt -S --needed thunderbird --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	internet

	elif [ "$internet" == "7" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#DESENVOLVIMENTO
desenvolvimento(){

desenvolvimento=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Desenvolvimento'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'Atom Editor' \
	    2 'Netbeans' \
	    3 'Sublime Text' \
	    4 'Eclipse' \
	    5 'Android Studio' \
	    6 'MySQL Workbench' \
	    7 'Code::Blocks' \
	    8 'Voltar' \
            0 'Sair'                )

	[ $? -ne 0 ] && return

	if [ "$desenvolvimento" == "1" ]; then
	clear
	yaourt -S atom-editor --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "2" ]; then
	clear
	yaourt -S --needed netbeans --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "3" ]; then
	clear
	yaourt -S sublime-text --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "4" ]; then
	clear
	yaourt -S --needed eclipse --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "5" ]; then
	clear
	yaourt -S android-studio jdk --noconfirm
	archlinux-java set java-8-jdk
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "6" ]; then
	clear
	yaourt -S --needed mysql-workbench --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "7" ]; then
	clear
	yaourt -S --needed codeblocks --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	desenvolvimento

	elif [ "$desenvolvimento" == "8" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#APARENCIA E PERSONALIZACAO
aparencia(){

aparencia=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Aparencia e Personalizacao'  \
             --menu 'Selecione a categoria para prosseguir:' \
            0 0 0                   \
            1 'Temas' \
	    2 'Icones' \
	    3 'Cursores' \
	    4 'Voltar' \
            0 'Sair'                )

	[ $? -ne 0 ] && return

	if [ "$aparencia" == "1" ]; then
	clear
	temas
	aparencia

	elif [ "$aparencia" == "2" ]; then
	clear
	icones
	aparencia

	elif [ "$aparencia" == "3" ]; then
	clear
	cursor
	aparencia

	elif [ "$aparencia" == "4" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#TEMAS
temas(){

temas=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Temas'  \
             --menu 'Selecione o tema para instalar:' \
            0 0 0                   \
            1 'Theme Arc' \
	    2 'Theme Numix' \
	    3 'Theme Numix Frost' \
	    4 'Voltar'   )

	[ $? -ne 0 ] && return

	if [ "$temas" == "1" ]; then
	clear
	yaourt -S gtk-theme-arc-git --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	temas

	elif [ "$temas" == "2" ]; then
	clear
	yaourt -S --needed numix-themes --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	temas

	elif [ "$temas" == "3" ]; then
	clear
	yaourt -S --needed numix-frost-themes --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	temas

elif [ "$temas" == "4" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#ICONES
icones(){

icones=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Icones'  \
             --menu 'Selecione o icone para instalar:' \
            0 0 0                   \
            1 'Numix Icon' \
	    2 'Numix Circle Icon' \
	    3 'Vibrancy Colors Icon' \
	    4 'Voltar' )

	[ $? -ne 0 ] && return

	if [ "$icones" == "1" ]; then
	clear
	yaourt -S numix-icon-theme-git --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	icones

	elif [ "$icones" == "2" ]; then
	clear
	yaourt -S numix-circle-icon-theme-git --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	icones

	elif [ "$icones" == "3" ]; then
	clear
	yaourt -S vibrancy-colors --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	icones

	elif [ "$icones" == "4" ]; then
	clear
	tic
else
echo 'Saindo do programa...'
fi
}
menu

#CURSOR
cursor(){

cursor=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Cursores'  \
             --menu 'Selecione o cursor para instalar:' \
            0 0 0                   \
            1 'Breeze Obsidian Cursor' \
	    2 'Breeze Snow Cursor' \
	    3 'Breeze Hacked Cursor' \
	    4 'Voltar' )

	[ $? -ne 0 ] && return

	if [ "$cursor" == "1" ]; then
	clear
	yaourt -S breeze-obsidian-cursor-theme --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	cursor

	elif [ "$cursor" == "2" ]; then
	clear
	yaourt -S breeze-snow-cursor-theme --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	cursor

	elif [ "$cursor" == "3" ]; then
	clear
	yaourt -S breeze-hacked-cursor-theme --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	cursor

	elif [ "$cursor" == "4" ]; then
	clear
	tic
else
echo 'Saindo do programa...'
fi
}
menu

#IMAGEM E VIDEO
imagemvideo(){

imagemvideo=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Imagem e Video'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'Inkscape' \
	    2 'Gimp' \
	    3 'Blender' \
	    4 'Kdenlive' \
	    8 'Voltar' \
	    0 'Sair'	 )

	[ $? -ne 0 ] && return

	if [ "$imagemvideo" == "1" ]; then
	clear
	yaourt -S --needed inkscape --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	imagemvideo

	elif [ "$imagemvideo" == "2" ]; then
	clear
	yaourt -S --needed gimp --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	imagemvideo

	elif [ "$imagemvideo" == "3" ]; then
	clear
	yaourt -S --needed blender --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	imagemvideo

	elif [ "$imagemvideo" == "4" ]; then
	clear
	yaourt -S --needed kdenlive --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	imagemvideo

	elif [ "$imagemvideo" == "8" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#ESCRITORIO
office(){

office=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Escritorio'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'LibreOffice' \
	    2 'WPS Office' \
	    8 'Voltar' \
	    0 'Sair' )

	[ $? -ne 0 ] && return

	if [ "$office" == "1" ]; then
	clear
	pacman -S --needed libreoffice-fresh libreoffice-fresh-pt-BR --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	office

	elif [ "$office" == "2" ]; then
	clear
	yaourt -S --needed wps-office wps-office-extension-portuguese-brazilian-dictionary --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	office

	elif [ "$office" == "8" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#VIRTUALIZACAO
vm(){

vm=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Virtualizacao e Containers'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1 'VirtualBox' \
	    2 'Docker' \
	    8 'Voltar' \
	    0 'Sair' 	)

	[ $? -ne 0 ] && return

	if [ "$vm" == "1" ]; then
	clear
	yaourt -S --needed virtualbox virtualbox-guest-iso virtualbox-ext-vnc virtualbox-sdk virtualbox-host-dkms virtualbox-host-modules --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	vm

	elif [ "$vm" == "2" ]; then
	clear
	yaourt -S --needed docker --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	vm

	elif [ "$vm" == "8" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#OUTROS
outros(){

outros=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Outros'  \
             --menu 'Selecione o programa para instalar:' \
            0 0 0                   \
            1  'Teamviewer' \
	    2  'AnyDesk' \
	    3  'Java JRE' \
	    4  'JDK' \
	    5  'Flareget' \
	    6  'Skype' \
	    7  'qbittorrent' \
	    8  'Remmina' \
	    9  'PlayOnLinux' \
	    10 'Terminator' \
	    11 'Gparted' \
	    12 'Terminix' \
	    13 'GDM 3 Setup'	\
	    14 'Voltar' \
            0  'Sair'                )

	[ $? -ne 0 ] && return

	if [ "$outros" == "1" ]; then
	clear
	yaourt -S --needed teamviewer --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "2" ]; then
	clear
	yaourt -S --needed anydesk --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "3" ]; then
	clear
	yaourt -S jre --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "4" ]; then
	clear
	yaourt -S jdk --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "5" ]; then
	clear
	yaourt -S flareget --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "6" ]; then
	clear
	yaourt -S skype --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "7" ]; then
	clear
	yaourt -S qbittorrent --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "8" ]; then
	clear
	yaourt -S remmina --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "9" ]; then
	clear
	yaourt -S --needed playonlinux --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "10" ]; then
	clear
	yaourt -S --needed terminator --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "11" ]; then
	clear
	yaourt -S --needed gparted --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "12" ]; then
	clear
	yaourt -S --needed terminix-git --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "13" ]; then
	clear
	yaourt -S --needed gdm3setup archlinux-artwork --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	outros

	elif [ "$outros" == "14" ]; then
	clear
	programas
else
echo 'Saindo do programa...'
fi
}
menu

#MENU
menu(){

opcao=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Menu'  \
             --menu 'Selecione a opcao:' \
            0 0 0                   \
            1  'Instalacao basica padrao [PACMAN] (#ROOT)' \
	    2  'Instalacao completa padrao [YAOURT] ($NO-ROOT)' \
	    3  'Central de Programas' \
	    4  'Verificar Atualizacao do Sistema' \
	    5  'Limpar Cache e arquivos temporarios' \
	    6  'Instalar' \
	    7  'Desinstalar' \
	    8  'Desinstalar com dependencias' \
	    9  'Buscar' \
	    10 'Status do Yaourt' \
	    11 'Reiniciar' \
	    12 'Sobre'	\
            0  'Sair'                )

	opcao=$opcao

	[ $? -ne 0 ] && return

	if [ "$opcao" == "1" ]; then
	root
	clear
	cd src
	sh install.sh
	cd ..

	menu

	elif [ "$opcao" == "2" ]; then
	noroot
	cd src
	sh installyaourt.sh
	cd ..

	menu

	elif [ "$opcao" == "3" ]; then
	noroot
	programas

    	elif [ "$opcao" == "4" ]; then
	noroot
	clear
	yaourt -Syua --noconfirm
	echo; echo "-> Precione enter para prosseguir..."
	read
	menu

    	elif [ "$opcao" == "5" ]; then
	noroot
	clear
	yaourt -Scc
	echo; echo "-> Precione enter para prosseguir..."
	read
	menu

	elif [ "$opcao" == "6" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Instalar' \
	    --inputbox 'Informe o nome do programa para instalar: ' 10 50)
	clear
	yaourt -S --needed $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

	elif [ "$opcao" == "7" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Desinstalar' \
	    --inputbox 'Informe o nome do programa para desinstalar: ' 10 50)
	clear
	yaourt -R $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

	elif [ "$opcao" == "8" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Desinstalar com dependencias' \
	    --inputbox 'Informe o nome do programa para desinstalar com as suas dependencias: ' 10 50)
	clear
	yaourt -Rscn $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

	elif [ "$opcao" == "9" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Buscar' \
	    --inputbox 'Informe o nome do programa para buscar: ' 10 50)
	clear
	yaourt $programa
	echo; echo "-> Precione enter para continuar"; read
	menu

	elif [ "$opcao" == "10" ]; then
	noroot
	clear
	yaourt --stats
	echo; echo "-> Precione enter para continuar"; read
	menu

	elif [ "$opcao" == "11" ]; then
	dialog --yesno 'Tem certeza que deseja reinciar?' 0 0
	if [ $? = 0 ]; then
	reboot
	else
 	menu
	fi
	menu

	elif [ "$opcao" == "0" ]; then
	echo "Saindo do programa..."
	exit

	menu
	elif [ "$opcao" == "12" ]; then
	dialog --title 'Sobre' --msgbox '\n
	\n
	########################################################################\n
	#                                                                      #\n
	#        ALT Project - Arch Linux Post Installation (alpi)             #\n
	#                                                                      #\n
	########################################################################\n
	\n
      	\n
	Arch Linux Post Installation (alpi), e uma ferramenta que permite facilitar a
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

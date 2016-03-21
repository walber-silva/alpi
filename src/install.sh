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

#CONFIGURACAO PADRAO - IDIOMA PT-BR - TECLADO ABNT2 - GNOME - Driver de Video Intel
#TECLADO
dialog --yesno 'Deseja alterar a Linguagem do teclado?' 0 0
if [ $? = 0 ]; then

keyboard=$( dialog --stdout --menu 'Alterar linguagem do teclado:' 0 0 0 X 'Manter a Linguagem atual' pt_BR 'Definir Portugues BR' + 'Definir manualmente' )

if [ "$keyboard" == "X" ]; then
dialog	\
--title 'Informacao!'	\
--msgbox 'Foi mantido sua linguagem atual.'	\
6 40

elif [ "$keyboard" == "pt_BR" ]; then
clear
LOCALEGEN="/etc/locale.gen"
if [ -e "$LOCALEGEN" ] ; then
 echo "-> Atualizando layout do teclado..."
 cat /etc/locale.gen | grep -v "pt_BR.UTF-8 UTF-8" > /etc/locale.tmp
 rm -f /etc/locale.gen
 mv /etc/locale.tmp /etc/locale.gen
 echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
 locale-gen
else
 echo "-> Criando configuracoes para pt_BR..."
 echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
 locale-gen
fi

dialog	\
--title 'Informacao!'	\
--msgbox 'Foi atualizado para pt_BR...'	\
6 40

elif [ "$keyboard" == "+" ]; then
nano /etc/locale.gen
clear

dialog	\
--title 'Informacao!'	\
--msgbox 'Voce definiu manualmente as configuracoes do teclado...'	\
6 40

fi
fi

#LINGUAGEM
dialog --yesno 'Deseja alterar a Linguagem do sistema?' 0 0
if [ $? = 0 ]; then

lang=$(locale | grep LANG | sed 's/LANG=//')
language=$( dialog --stdout --menu 'Atualizar Linguagem:' 0 0 0 $lang 'Manter a Linguagem atual' pt_BR 'Atualizar para Portugues BR' en_US 'Atualizar para Ingles' + 'Definir Linguagem manualmente' )

if [ "$language" == "$lang" ]; then
dialog	\
--title 'Informacao!'	\
--msgbox 'Foi mantida sua linguagem atual do sistema.'	\
6 40

elif [ "$language" == "pt_BR" ]; then
clear
LOCALECONF="/etc/locale.conf"
 if [ -e "$LOCALECONF" ] ; then
	clear
	echo "-> Atualizando configuracoes para pt_BR..."
	cat /etc/locale.conf | grep -v LANG=pt_BR.UTF-8 > /etc/locale.tmp
	rm -f /etc/locale.conf
	mv /etc/locale.tmp /etc/locale.conf
	echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
	export LANG=pt_BR.UTF-8
	rm -f /etc/localtime
	ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
 else
	echo "-> Criando configuracoes para pt_BR..."
	echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
	export LANG=pt_BR.UTF-8
	rm -f /etc/localtime
	ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
 fi
 dialog	\
 --title 'Informacao!'	\
 --msgbox 'Seu idioma foi atualizado para pt_BR...'	\
 6 40

elif [ "$language" == "en_US" ]; then

LOCALECONF="/etc/locale.conf"
 if [ -e "$LOCALECONF" ] ; then
	clear
	echo "-> Atualizando configuracoes para en_US..."
	cat /etc/locale.conf | grep -v LANG=en_US > /etc/locale.tmp
	rm -f /etc/locale.conf
	mv /etc/locale.tmp /etc/locale.conf
	echo "LANG=en_US" >> /etc/locale.conf
	export LANG=en_US
 else
	echo "-> Criando configuracoes para en_US..."
	echo "LANG=en_US" >> /etc/locale.conf
	export LANG=en_US
 fi

 dialog	\
 --title 'Informacao!'	\
 --msgbox 'Seu idioma foi atualizado para en_US...'	\
 6 40

elif [ "$language" == "+" ]; then
nano /etc/locale.conf
clear

dialog	\
--title 'Informacao!'	\
--msgbox 'Voce definiu manualmente a linguagem...'	\
6 40

fi
fi

#Atualiza Configuracoes do pacman
clear
echo "-> Atualizando configuracoes do pacman..."
rm -f /etc/pacman.conf
cp pacman.conf /etc/

#Verificando se o pacman esta sendo usado por outro processo
FILE="/var/lib/pacman/db.lck"
if [ -e "$FILE" ] ; then
echo "-> Pacman esta sendo usado por outro processo.."
echo "-> Parando processo.."
rm /var/lib/pacman/db.lck
else
echo "-> [OK] Pacman nao esta sendo usado por nenhum processo.."
fi

#Definindo Hostname
hostname=$(dialog --stdout \
	    --backtitle 'Definir Hostname' \
	    --inputbox 'Informe um nome para a sua maquina: ' 10 50)
clear
echo $hostname > /etc/hostname

createuser(){
#Criando Usuario
user=$(dialog --stdout \
	    --backtitle 'Criar Usuario' \
	    --inputbox 'Informe o nome do novo usuario: ' 10 50)
clear
echo "Criando usuario..."	
useradd -m -G wheel -s /bin/bash $user
gpasswd -a $user storage
gpasswd -a $user disk
echo "Adicionando usuario ao arquivo sudoers..."
echo "$user ALL=(ALL) ALL" >> /etc/sudoers
echo "Definindo senha..."
passwd $user
}

dialog --yesno 'Deseja criar um novo usuario?' 0 0
if [ $? = 0 ]; then
createuser
fi

#Instala pacotes base de video
clear
echo "-> Instalando drivers basicos de video..."
pacman -Syu --noconfirm
pacman -S --needed alsa-utils --noconfirm
pacman -S --needed xorg-server xorg-xinit xorg-server-utils --noconfirm
pacman -S --needed xf86-video-vesa --noconfirm
pacman -S --needed mesa --noconfirm
pacman -S --needed xorg-twm xorg-xclock xterm --noconfirm
pacman -S --needed ttf-dejavu --noconfirm

#Procura por atualizacoes do sistema
pacman -Syu --noconfirm

#Instalar DE
deinstall(){

de=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Ambiente de Trabalho'  \
             --menu 'Selecione um Ambiente de Trabalho para instalar:' \
            0 0 0                   \
            1 'GNOME' \
	    2 'KDE' \
	    3 'Xfce' \
	    4 'Cinnamon' \
	    5 'Mate' \
            0 'Sair'   )

	[ $? -ne 0 ] && break

if [ "$de" == "1" ]; then
clear
echo "Instalando GNOME..."
pacman -S gnome --needed --noconfirm
pacman -S gedit-plugins gnome-tweak-tool gnome-power-manager gucharmap gvfs-goa --needed --noconfirm
systemctl enable gdm.service
deinstall

elif [ "$de" == "2" ]; then
clear
echo "Instalando KDE..."
pacman -S plasma sddm --needed --noconfirm
systemctl start sddm

elif [ "$de" == "3" ]; then
clear
echo "Instalando Xfce..."
pacman -S xfce4 xfce4-goodies xarchiver mupdf --needed --noconfirm
echo "exec start xfce4" >> ~/.xinitrc
pacman -S lightdm lightdm-gtk-greeter --needed --noconfirm
systemctl enable lightdm.service

elif [ "$de" == "4" ]; then
clear
echo "Instalando Cinnamon..."
pacman -S cinnamon --needed --noconfirm
echo "exec cinnamon-session" >> ~/.xinitrc
pacman -S lightdm lightdm-gtk-greeter --needed --noconfirm
systemctl enable lightdm.service

elif [ "$de" == "5" ]; then
clear
echo "Instalando Mate..."
pacman -S mate mate-extra --needed --noconfirm
echo "exec mate-session" >> ~/.xinitrc
pacman -S lightdm lightdm-gtk-greeter --needed --noconfirm
systemctl enable lightdm.service

fi
}

dialog --yesno 'Deseja instalar algum Ambiente de Trabalho?' 0 0
if [ $? = 0 ]; then
deinstall
fi

#Network
clear
echo "Instalando e configurando suporte a Wireless"
pacman -S --needed networkmanager network-manager-applet --noconfirm
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

#Basic
echo "Instalando programas basicos..."
pacman -S --needed vim nano mlocate guake git wget dialog openssh --noconfirm
pacman -S --needed firefox gst-libav gst-plugins-good upower --noconfirm

#Libre Office
dialog --yesno 'Deseja instalar LibreOffice?' 0 0
if [ $? = 0 ]; then
clear
pacman -S --needed libreoffice-fresh libreoffice-fresh-pt-BR --noconfirm
fi

#Suport Not Intel & Touchpad
dialog --yesno 'Deseja Instalar Driver de video Intel e driver para Touchpad?' 0 0
if [ $? = 0 ]; then
clear
pacman -S --needed xf86-input-synaptics --noconfirm
pacman -S --needed xf86-video-intel --noconfirm
fi

#Suport Disk
clear
pacman -S --needed dosfstools ntfs-3g nilfs-utils mtools f2fs-tools exfat-utils nilfs-utils gpart ntfs-3g gvfs-mtp --noconfirm

#Suporte smartphone android - gvfs-mtp

#Others
pacman -S --needed file-roller gst-libav p7zip unrar unace lrzip cdrkit samba gnome-tweak-tool gparted gedit qt4 vde2 net-tools --noconfirm
pacman -S --needed vlc smplayer screenfetch --noconfirm

#Install Yaourt
echo "-> Instalando Yaourt..."
pacman -U *.pkg.tar.xz --noconfirm

#VirtualBox
dialog --yesno 'Deseja Instalar o VirtualBox?' 0 0
if [ $? = 0 ]; then
clear
pacman -S --needed virtualbox virtualbox-guest-iso virtualbox-ext-vnc virtualbox-sdk virtualbox-host-dkms --noconfirm

#Verificando se existe o arquivo de configuracao do virtualbox
FILE="/etc/modules-load.d/virtualbox.conf"
if [ -e "$FILE" ] ; then
echo "-> Arquivo existe.."
echo "-> Removendo arquivo.."
rm -f /etc/modules-load.d/virtualbox.conf
echo "-> Atualizando arquivo..."
echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf
echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf
echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf
echo "vboxpci" >> /etc/modules-load.d/virtualbox.conf
gpasswd -a $USER vboxusers
else
echo "-> Nao existe arquivo de configuracao do virtualbox"
echo "-> Criando arquivo..."
echo "vboxdrv" >> /etc/modules-load.d/virtualbox.conf
echo "vboxnetadp" >> /etc/modules-load.d/virtualbox.conf
echo "vboxnetflt" >> /etc/modules-load.d/virtualbox.conf
echo "vboxpci" >> /etc/modules-load.d/virtualbox.conf

gpasswd -a $USER vboxusers
fi
fi

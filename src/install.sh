#!/bin/bash
##################################################
# Name: Arch Linux Pos Installation (alpi)
# Description: Pos Installation for Arch Linux
# Script Maintainer: ALT Project
#
# Last Updated: 12/01/2016
##################################################
#
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

#CONFIGURACAO PADRAO - IDIOMA PT-BR - TECLADO ABNT2
LOCALEGEN="/etc/locale.gen"
if [ -e "$LOCALEGEN" ] ; then
echo "-> Atualizando configuracoes de Locale.gen para pt_BR..."
cat /etc/locale.gen | grep -v "pt_BR.UTF-8 UTF-8" > /etc/locale.tmp
rm -f /etc/locale.gen
mv /etc/locale.tmp /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
else
echo "-> Criando configuracoes para Locale.gen pt_BR..."
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
fi

LOCALECONF="/etc/locale.conf"
if [ -e "$LOCALECONF" ] ; then
echo "-> Atualizando configuracoes de Locale.conf para pt_BR..."
cat /etc/locale.conf | grep -v LANG=pt_BR.UTF-8 > /etc/locale.tmp
rm -f /etc/locale.conf
mv /etc/locale.tmp /etc/locale.conf
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
export LANG=pt_BR.UTF-8
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
else
echo "-> Criando configuracoes para Locale.conf pt_BR..."
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
export LANG=pt_BR.UTF-8
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime
fi


#Atualiza Configuracoes do pacman
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


#echo "Adicionando usuario ao Sudoers"
#echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

#Permissao Usuario
#chown -R $USER /home/$USER/

#Instala pacotes base de video
pacman -Syu --noconfirm
pacman -S --needed alsa-utils --noconfirm
pacman -S --needed xorg-server xorg-xinit xorg-server-utils --noconfirm
pacman -S --needed xf86-video-vesa --noconfirm
pacman -S --needed mesa --noconfirm
pacman -S --needed xorg-twm xorg-xclock xterm --noconfirm
pacman -S --needed ttf-dejavu --noconfirm

#Procura por atualizacoes do sistema
pacman -Syu --noconfirm

#Instala o Gnome
pacman -S gnome --needed --noconfirm

# Habilita o GDM
systemctl enable gdm.service

#Network
pacman -S --needed networkmanager network-manager-applet --noconfirm
systemctl enable NetworkManager.service
systemctl start NetworkManager.service

#Basic
pacman -S --needed vim nano mlocate guake git wget dialog terminator --noconfirm
pacman -S --needed firefox gst-libav gst-plugins-good upower screenfetch --noconfirm

#Libre Office
pacman -S --needed libreoffice-fresh libreoffice-fresh-pt-BR --noconfirm

#Suport Not Intel & Touchpad
pacman -S --needed xf86-input-synaptics --noconfirm
pacman -S --needed xf86-video-intel --noconfirm

#Suport Disk
pacman -S --needed dosfstools ntfs-3g nilfs-utils mtools f2fs-tools exfat-utils nilfs-utils gpart ntfs-3g gvfs-mtp --noconfirm

#Suporte smartphone android - gvfs-mtp  

#Others
pacman -S --needed file-roller gst-libav p7zip unrar unace lrzip cdrkit samba gnome-tweak-tool gparted gedit qt4 vde2 net-tools vlc smplayer --noconfirm

#Install Yaourt
echo "-> Instalando Yaourt..."
pacman -U *.pkg.tar.xz --noconfirm

#VirtualBox ---------------------------------------------------------
pacman -S --needed virtualbox virtualbox-guest-iso virtualbox-ext-vnc virtualbox-sdk virtualbox-host-dkms virtualbox-host-modules --noconfirm

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

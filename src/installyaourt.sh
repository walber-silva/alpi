#!/bin/bash
##################################################
# Name: Arch Linux Pos Installation (alpi)
# Description: Pos Installation for Arch Linux
# Script Maintainer: ALT Project
#
# Last Updated: 12/01/2016
##################################################
#
#Variaveis
packagequery='https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz'
yaourt='https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz'

if [ "$(id -u)" == "0" ]; then
echo ""
echo "--- :( ----------------------------------------------"
echo ""
echo "    Voce nao pode continuar sendo root."
echo ""
exit 1
fi

#Verifica se yaourt esta instalado
verify=$(which yaourt)
if [ "$verify" == "/usr/bin/yaourt" ] || [ "$verify" == "/usr/sbin/yaourt" ]; then
echo '-> [OK] Yaourt esta instalado...'
else
echo '-> Yaourt nao esta instalado. :('
echo '-> Instalando Yaourt...'
wget $packagequery $yaourt
tar -xf package-query.tar.gz
tar -xf yaourt.tar.gz 
cd package-query
makepkg -sic --noconfirm
cd ..
cd yaourt
makepkg -sic --noconfirm
cd ..
rm -fR yaourt packa* yaour*
fi

yaourt -Syua --noconfirm
yaourt -S --needed teamviewer --noconfirm
yaourt -S --needed flareget --noconfirm
yaourt -S --needed skype --noconfirm 
yaourt -S --needed google-chrome --noconfirm
yaourt -S --needed mysql-workbench --noconfirm
yaourt -S --needed qbittorrent --noconfirm
yaourt -S --needed gimp --noconfirm
yaourt -S --needed gpaint --noconfirm
yaourt -S --needed remmina --noconfirm
yaourt -S --needed breeze-obsidian-cursor-theme --noconfirm
yaourt -S --needed breeze-snow-cursor-theme --noconfirm 
yaourt -S --needed numix-themes-archblue-git --noconfirm
yaourt -S --needed numix-circle-icon-theme-git --noconfirm
yaourt -S --needed gtk-theme-arc-git --noconfirm
yaourt -S --needed ttf-ms-fonts --noconfirm
echo
echo "Instalacao concluida.."

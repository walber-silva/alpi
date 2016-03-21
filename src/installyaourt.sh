#!/bin/bash
##################################################
# Name: Arch Linux Post Installation (alpi)
# Description: Pos Instalacao para Arch Linux
# Script Maintainer: ALT Project
#
##################################################
#
#Variaveis
clear
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
rm -fR packa* yaour*
fi

yaourt -Syua --noconfirm
yaourt -S --needed google-chrome --noconfirm
yaourt -S --needed qbittorrent --noconfirm
yaourt -S --needed gimp --noconfirm
yaourt -S --needed remmina --noconfirm
yaourt -S --needed ttf-ms-fonts --noconfirm
echo
echo "Processo concluido.."

#!/bin/bash
##################################################
# Name: Arch Linux Post Installation (alpi)
# Description: Pos Instalacao para Arch Linux
# Script Maintainer: Tiago R. Lampert
##################################################
#
NAME="Arch Linux Post Installation (ALPI)"
VERSION=" Versao 1.1.0"

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
(cd package-query || exit
makepkg -sic --noconfirm
)
(cd yaourt || exit
makepkg -sic --noconfirm
)
rm -fR packa* yaour*
fi

# Install ZSH + Oh-My-ZSH + Powerline Theme
dialog --yesno 'Deseja Instalar Oh-My-ZSH com Powerline Theme? AVISO! ZSH sera definido como seu shell padrao!' 0 0
if [ $? = 0 ]; then
clear

# Copy config Terminator
cp -R terminator /$HOME/.config/

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git
cd fonts/
sh install.sh
cd ..
rm -fR fonts

# Install ZSH
echo "Instalando ZSH..."
yaourt -S zsh zsh-lovers powerline powerline-common --needed --noconfirm
yaourt -S adobe-source-code-pro-fonts --needed --noconfirm

cp zsh.tar /$HOME/ ; cd /$HOME/
tar -xvf zsh.tar
rm -f zsh.tar

# ZSH Default Shell
sudo usermod -s /bin/zsh $(whoami)

echo 'export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="powerline"
# ---------------------------------------------------
# Yaourt
# ---------------------------------------------------
alias yy="yaourt -Sy "
alias yu="yaourt -Syu "
alias ya="yaourt -Syua "
alias yi="yaourt -S "
alias yrd="yaourt -Rscn "
alias yr="yaourt -R "
alias yl="yaourt -Q "
alias yfl="yaourt -Q | grep "
alias ys="yaourt --stats"
source $ZSH/oh-my-zsh.sh' > /$HOME/.zshrc

echo 'ZSH_THEME="powerline"' > /$HOME/.zshrc.pre-oh-my-zsh

fi

# Install Theme and Icons
dialog --yesno 'Deseja Instalar Temas e icones adicionais?' 0 0
if [ $? = 0 ]; then
  clear
  yaourt -S adapta-gtk-theme paper-icon-theme-git --noconfirm
fi

clear
echo "Verificando atualizacao no sistema..."
yaourt -Syua --noconfirm

echo "Instalando Google Chrome, qBittorrent, Gimp..."
yaourt -S --needed google-chrome --noconfirm
yaourt -S virtualbox-ext-oracle --noconfirm
yaourt -S --needed qbittorrent --noconfirm
yaourt -S --needed gimp --noconfirm
yaourt -S --needed ttf-ms-fonts --noconfirm
echo
echo "Processo concluido.."

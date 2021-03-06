#!/bin/bash
##################################################
# Name: Arch Linux Post Installation (alpi)
# Description: Pos Instalacao para Arch Linux
# Script Maintainer: Tiago R. Lampert
##################################################
#
NAME="Arch Linux Post Installation (ALPI)"
VERSION=" Versao 1.1.0"

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
set_hostname(){
hostname=$(dialog --stdout \
	    --backtitle 'Definir Hostname' \
	    --inputbox 'Informe um nome para a sua maquina: ' 10 50)
clear
if [ "$hostname" ==  "" ]; then
  set_hostname

else
  echo $hostname > /etc/hostname
fi
}

dialog --yesno 'Deseja alterar o nome da maquina?' 0 0
if [ $? = 0 ]; then
set_hostname
fi

createuser(){
#Criando Usuario
user=$(dialog --stdout \
	    --backtitle 'Criar Usuario' \
	    --inputbox 'Informe o nome do novo usuario: ' 10 50)
clear
if [ "$user" ==  "" ]; then
createuser
else

echo "Criando usuario..."
useradd -m -G wheel,storage,power,network,video,audio,disk,lp -s /bin/bash $user
echo "Adicionando usuario ao arquivo sudoers..."
echo "$user ALL=(ALL) ALL" >> /etc/sudoers
echo "Definindo senha..."
passwd $user
fi
}

dialog --yesno 'Deseja criar um novo usuario?' 0 0
if [ $? = 0 ]; then
createuser
fi

passwdroot(){
  echo "Informe a senha de root: "
  passwd root
}

dialog --yesno 'Deseja criar ou alterar a senha de root?' 0 0
if [ $? = 0 ]; then
clear
passwdroot
fi

#Instala pacotes base de video
clear
base_video(){
clear
echo "-> Instalando drivers basicos de video..."
pacman -Syu --noconfirm
pacman -S --needed alsa-utils --noconfirm
pacman -S --needed xorg-server xorg-xinit xorg-server-utils --noconfirm
pacman -S --needed xf86-video-vesa --noconfirm
pacman -S --needed mesa --noconfirm
pacman -S --needed xorg-twm xorg-xclock xterm --noconfirm
pacman -S --needed ttf-dejavu --noconfirm
}

dialog --yesno 'Deseja instalar drivers basicos de video?' 0 0
if [ $? = 0 ]; then
base_video
fi


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
      0 'Continuar'   )

	[ $? -ne 0 ] && return

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
  pacman -S plasma plasma-meta plasma-desktop kde-applications breeze-gtk kde-gtk-config --needed --noconfirm
  systemctl enable sddm

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
network(){
  clear
  echo "Instalando e configurando suporte a Rede e Wireless"
  pacman -S --needed networkmanager network-manager-applet --noconfirm
  systemctl enable NetworkManager.service
  systemctl start NetworkManager.service
  systemctl enable dhcpcd
}
  network

#Programas Basicos
prog_basic(){
  echo "Instalando programas basicos..."
  pacman -S --needed vim nano mlocate guake git wget dialog openssh terminator --needed --noconfirm
  pacman -S --needed firefox gst-libav gst-plugins-good upower --needed --noconfirm
  pacman -S --needed file-roller gst-libav p7zip unrar unace lrzip cdrkit samba gnome-tweak-tool gparted gedit qt4 vde2 net-tools --needed --noconfirm
  pacman -S --needed vlc smplayer screenfetch adobe-source-code-pro-fonts gdm3setup archlinux-artwork --needed --noconfirm
}

dialog --yesno 'Deseja instalar alguns programas basicos? (... vim, nano, firefox, vlc, smplayer, git)' 0 0
if [ $? = 0 ]; then
  clear
  prog_basic
fi

#CUPS
dialog --yesno 'Deseja instalar CUPS?' 0 0
if [ $? = 0 ]; then
  clear
  # Install packages
  pacman -S cups ghostscript gsfonts samba --noconfirm --needed

  # Enable services
  systemctl enable org.cups.cupsd.service
  systemctl start org.cups.cupsd.service

  systemctl enable cups-browsed.service
  systemctl start cups-browsed.service

  # List services
  systemctl list-units --type=service | grep cups
fi

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
echo "Instalando pacotes e bibliotecas para suporte a outros sistemas de arquivos..."
pacman -S --needed dosfstools ntfs-3g nilfs-utils mtools f2fs-tools exfat-utils nilfs-utils gpart ntfs-3g gvfs-mtp --noconfirm

#Suporte smartphone android - gvfs-mtp

#Install Yaourt
echo "-> Instalando Yaourt..."
pacman -U *.pkg.tar.xz --noconfirm

#VirtualBox
dialog --yesno 'Deseja Instalar o VirtualBox?' 0 0
if [ $? = 0 ]; then
  clear
  pacman -S linux-headers --needed --noconfirm
  pacman -S virtualbox virtualbox-host-modules-arch virtualbox-guest-iso  --needed --noconfirm
  modprobe vboxdrv
  gpasswd -a $USER vboxusers
fi

# Install ZSH + Oh-My-ZSH + Powerline Theme
dialog --yesno 'Deseja Instalar Oh-My-ZSH com Powerline Theme? AVISO! ZSH sera definido como seu shell padrao!' 0 0
if [ $? = 0 ]; then
  clear
  # Copy config Terminator
  cp -R terminator /root/.config/

  # Install Powerline Fonts
  git clone https://github.com/powerline/fonts.git
  cd fonts/
  sh install.sh
  cd ..
  rm -fR fonts

  # Install ZSH
  echo "Instalando ZSH..."
  pacman -S zsh zsh-lovers powerline powerline-common --needed --noconfirm
  pacman -S adobe-source-code-pro-fonts --needed --noconfirm

  # Verifica se e root e instala ZSH em /root
  if [ "`whoami`" == "root" ];
  then
    # ZSH Default Shell
    usermod -s /bin/zsh root
    cp zsh.tar /root/ ; cd /root/
    tar -xvf zsh.tar
    rm -f zsh.tar
  fi
fi

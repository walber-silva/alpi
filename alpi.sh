#!/bin/bash
##################################################
# Name: Arch Linux Post Installation (alpi)
# Description: Pos Instalacao para Arch Linux
# Script Maintainer: Tiago R. Lampert
##################################################
#
NAME="Arch Linux Post Installation (ALPI)"
VERSION=" Versao 1.1.0"

# Show Logo
logo(){
  dialog	\
  --backtitle "$NAME - $VERSION" \
  --title 'Arch Linux Post Installation'	\
  --infobox '\n
                    -`\n
                   .o+`\n
                  `ooo/\n
                 `+oooo:\n
                `+oooooo:\n
                -+oooooo+:\n
              `/:-:++oooo+:\n
             `/++++/+++++++:\n
            `/++++++++++++++:\n
           `/+++ooooooooooooo/`\n
          ./ooosssso++osssssso+`\n
         .oossssso-````/ossssss+`\n
        -osssssso.      :ssssssso.\n
       :osssssss/        osssso+++.\n
      /ossssssss/        +ssssooo/-\n
    `/ossssso+/:-        -:/+osssso+-\n
   `+sso+:-`                 `.-/+oso:\n
  `++:.                           `-/+/\n
  .`
  '	\
  0 0  && sleep 3
}

logo

# Verifica se existe conexao com a internet
test_network(){
dialog --backtitle "$NAME - $VERSION" --title " Informacao!" --infobox " \nVerificando conexao..." 0 0 && sleep 2
while [[ ! $(ping -c1 8.8.8.8) ]]; do
dialog	\
--title 'Aviso!'	\
--msgbox '  Nao foi possivel conectar-se a internet..
  Por favor Verifique sua conexão!

  AVISO! Caso deseje continuar, algumas coisas
  poderão não funcionar corretamente!'	\
9 55
clear
break
done
clear
}
test_network
clear

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
(cd package-query || exit
makepkg -sic --noconfirm
)
(cd yaourt || exit
makepkg -sic --noconfirm
)
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

echo "-> [OK] Verificando dependencias..."

#Verifica se e root para usar pacman
if [ "$(id -u)" == "0" ]; then
pacman -Sy --noconfirm
pacman -S --needed dialog wget sudo --noconfirm
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
sudo pacman -S --needed wget dialog sudo --noconfirm
yaourtinstall
yaourt -Sy --noconfirm
yaourt -S --needed dialog --noconfirm
fi

echo "-> [OK] Iniciando aplicacao..."

#Instalar Bootloader
bootloader_install(){
bl=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Bootloader'  \
             --menu 'Selecione um Bootloader para instalar:' \
            0 0 0                   \
      1 'GRUB BIOS-MBR' \
	    2 'GRUB  UEFI-GPT' \
	    3 'rEFInd  UEFI-GPT' \
      4 'Voltar' \
      0 'Sair'   )

	[ $? -ne 0 ] && return

if [ "$bl" == "1" ]; then
  clear
  echo "Instalando GRUB - BIOS..."
  sudo pacman -Sy; sudo pacman -S --needed grub os-prober --noconfirm
  sudo grub-install /dev/sda
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  sudo mkinitcpio -p linux
  echo ""
  echo "Precione enter para voltar ao menu..."
  pause
  menu

elif [ "$bl" == "2" ]; then
  clear
  echo "Instalando GRUB - UEFI..."
  sudo pacman -Sy; sudo pacman -S --needed grub efibootmgr os-prober --noconfirm
  sudo grub-install --target=x86_64-efi --efi-directory=boot --bootloader-id=arch_grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  sudo mkinitcpio -p linux
  echo ""
  echo "Precione enter para voltar ao menu..."
  pause
  menu

elif [ "$bl" == "3" ]; then
  clear
  echo "Instalando rFind - UEFI..."
  sudo pacman -Sy; sudo pacman -S --needed refind-efi efibootmgr --noconfirm
  sudo refind-install
  echo ""
  echo "Precione enter para voltar ao menu..."
  pause
  menu

elif [ "$bl" == "4" ]; then
  menu

fi
}

#MENU
menu(){

opcao=$(
      dialog --backtitle "$NAME - $VERSION" \
	     --stdout               \
             --title 'Menu'  \
             --menu 'Selecione uma opcao:' \
            0 0 0                   \
      1  'Instalacao padrao [PACMAN] (#ROOT)' \
	    2  'Instalacao adicional [YAOURT] ($NO-ROOT)' \
	    3  'Verificar Atualizacao do Sistema' \
	    4  'Limpar Cache e arquivos temporarios' \
	    5  'Instalar' \
	    6  'Desinstalar' \
	    7  'Desinstalar com dependencias' \
	    8  'Buscar' \
	    9  'Status do Yaourt' \
      10 'Instalar Bootloader' \
	    11 'Reiniciar' \
	    12 'Sobre'	\
      0  'Sair'                )

	opcao=$opcao

	[ $? -ne 0 ] && return

	if [ "$opcao" == "1" ]; then
	root
	clear
	cd src/
	sh install.sh

	menu

	elif [ "$opcao" == "2" ]; then
	noroot
	cd src/
	sh installyaourt.sh

	menu

  elif [ "$opcao" == "3" ]; then
	noroot
	clear
	yaourt -Syua --noconfirm
	echo; echo "-> Precione enter para prosseguir..."
	read
	menu

  elif [ "$opcao" == "4" ]; then
	noroot
	clear
	yaourt -Scc
	echo; echo "-> Precione enter para prosseguir..."
	read
	menu

  elif [ "$opcao" == "5" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Instalar' \
	    --inputbox 'Informe o nome do programa para instalar: ' 10 50)
	clear
	yaourt -S --needed $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

  elif [ "$opcao" == "6" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Desinstalar' \
	    --inputbox 'Informe o nome do programa para desinstalar: ' 10 50)
	clear
	yaourt -R $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

  elif [ "$opcao" == "7" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Desinstalar com dependencias' \
	    --inputbox 'Informe o nome do programa para desinstalar com as suas dependencias: ' 10 50)
	clear
	yaourt -Rscn $programa --noconfirm
	echo; echo "-> Precione enter para continuar"; read
	menu

  elif [ "$opcao" == "8" ]; then
	noroot
	clear
	programa=$(dialog --stdout \
	    --backtitle 'Buscar' \
	    --inputbox 'Informe o nome do programa para buscar: ' 10 50)
	clear
	yaourt $programa
	echo; echo "-> Precione enter para continuar"; read
	menu

  elif [ "$opcao" == "9" ]; then
	noroot
	clear
	yaourt --stats
	echo; echo "-> Precione enter para continuar"; read
	menu

  elif [ "$opcao" == "10" ]; then
  clear
  bootloader_install
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
  clear
	echo "Saindo do ALPI..."
	exit

	menu
  elif [ "$opcao" == "12" ]; then
	dialog --title 'Sobre' --msgbox '\n
	\n
	 ###########################################################################\n
	 #                                                                         #\n
  #                  Arch Linux Post Installation (ALPI)                    #\n
  #                                                                         #\n
  # Configure e instale pacotes no Arch Linux facilmente após a instalação! #\n
  #                                                                         #\n
  #                                2016                                     #\n
	 ###########################################################################\n
	' 15 85

	menu


else
echo 'Saindo do programa...'
fi
}
menu

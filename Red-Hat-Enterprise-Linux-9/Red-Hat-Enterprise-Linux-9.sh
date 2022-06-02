#!/bin/bash

# Variables
cpuarch=$(uname -m)
core=$(nproc)
snap_path_is_include=$(export PATH="$PATH:/snap/bin/")
scripts_path=$(find / -name scripts | grep -i "Red-Hat-Enterprise-Linux-9/scripts" | head -n 1)
local_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
# Select Which Softwares to be Installed

choice () {
    local choice=$1
    if [[ ${opts[choice]} ]] # toggle
    then
        opts[choice]=
    else
        opts[choice]=+
    fi
}
PS3='
Please enter your choice(s): '
while :
do
    clear
    options=("PHP ${opts[1]}" "Nginx ${opts[2]}" "Apache ${opts[3]}" "Grub Customizer ${opts[4]}" "Linux Kernel ${opts[5]}" 
    "FFmpeg ${opts[6]}" "OpenSSL ${opts[7]}" "OpenSSH ${opts[8]}" "Done ${opts[9]}")
    select opt in "${options[@]}"
    do
        case $opt in
            "PHP ${opts[1]}")
                choice 1
                break
                ;;
            "Nginx ${opts[2]}")
                choice 2
                break
                ;;
            "Apache ${opts[3]}")
                choice 3
                break
                ;;
            "Grub Customizer ${opts[4]}")
                choice 4
                break
                ;;
            "Linux Kernel ${opts[5]}")
                choice 5
                break
                ;;
            "FFmpeg ${opts[6]}")
                choice 6
                break
                ;;
            "OpenSSL ${opts[7]}")
                choice 7
                break
                ;;
            "OpenSSH ${opts[8]}")
                choice 8
                break
                ;;
            "Done ${opts[9]}")
                break 2
                ;;

            *) printf '%s\n' 'Please Choose Between 1-7';;
        esac
    done
done

printf '%s\n\n' 'Options chosen:'
for opt in "${!opts[@]}"
do
    if [[ ${opts[opt]} ]]
    then
        printf '%s\n' "Option $opt"
    fi
done

if [ "${opts[opt]}" = "" ];then
    exit
fi



# Loading Bar

printf "Installation starting"
value=0
while [ $value -lt 600 ];do
    value=$((value+20))
    printf "."
    sleep 0.05
done
printf "\n"


#Necessary Packages
CODEREADY_BUILDER=$(yum repolist | grep -qi "codeready-builder-for-rhel")
if [ -z "$CODEREADY_BUILDER" ];then
    :
else
    sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpm
fi

sudo dnf -vy install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf -vy install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
sudo dnf -vy install wget curl mlocate nano lynx net-tools htop git dnf yum snapd bash-completion dnf-utils
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl start snapd
export PATH=$PATH:/snap/bin
source /etc/profile
source /etc/profile.d/bash_completion.sh
printf "\n"

# Create Download Folder in root
if [ -d "/root/Downloads/" ];then
    :
else
    sudo mkdir -pv /root/Downloads/
fi

# INSTALLATION BY SELECTION

for opt in "${!opts[@]}"
do
    if [[ ${opts[opt]} ]]
    then
        case $opt in 
            1) 
            #PHP
            . "$scripts_path/1-Php.sh"
            ;;
            2)
            # 2- Nginx
            . "$scripts_path/2-Nginx.sh"
            ;;
            3)
            # 3- Apache
            . "$scripts_path/3-Apache.sh"
            ;;
            4)
            # 4- Grub Customizer
            . "$scripts_path/4-Grub-Customizer.sh"
            ;;
            5)
            # 5-Linux Kernel
            . "$scripts_path/5-Linux-Kernel.sh"
            ;;
            6)
            # 6-FFmpeg
            . "$scripts_path/6-Ffmpeg.sh"
            ;;
            7)
            # 7-OpenSSL
            . "$scripts_path/7-Openssl.sh"
            ;;
            8)
            # 8-OpenSSH
            . "$scripts_path/8-Openssh.sh"
            ;;
        esac
    fi
done
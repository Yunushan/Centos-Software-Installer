#!/bin/bash

# Variables
cpuarch=$(uname -m)
core=$(nproc)
snap_path_is_include=$(export PATH="$PATH:/snap/bin/")
scripts_path=$(find / -name scripts | grep -i "Red-Hat-Enterprise-Linux-9/scripts" | head -n 1)

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
    "FFmpeg ${opts[6]}" "OpenSSL ${opts[7]}" "OpenSSH ${opts[8]}" "Mysql ${opts[9]}" "OpenJDK 8-11-17 ${opts[10]}"
    "DVBlast 3.4 ${opts[11]}" "Zabbix Server ${opts[12]}" "UrBackup Server ${opts[13]}" "PostgreSQL ${opts[14]}" 
    "Done ${opts[15]}")
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
            "Mysql ${opts[9]}")
                choice 9
                break
                ;;
            "OpenJDK 8-11-17 ${opts[10]}")
                choice 10
                break
                ;;
            "DVBlast 3.4 ${opts[11]}")
                choice 11
                break
                ;;
            "Zabbix Server ${opts[12]}")
                choice 12
                break
                ;;
            "UrBackup Server ${opts[13]}")
                choice 13
                break
                ;;
            "PostgreSQL ${opts[14]}")
                choice 14
                break
                ;;
            "Done ${opts[15]}")
                break 2
                ;;

            *) printf '%s\n' 'Please Choose Between 1-15';;
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
local_ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')

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
            9)
            # 9-Mysql
            . "$scripts_path/8-Openssh.sh"
            ;;
            10)
            # 10-OpenJDK 8-11-17
            . "$scripts_path/10-Openjdk.sh"
            ;;
            11)
            # 11-DVBlast 3.4
            . "$scripts_path/11-Dvblast.sh"
            ;;
            12)
            # 12-Zabbix Server
            . "$scripts_path/12-Zabbix-Server.sh"
            ;;
            13)
            # 13-UrBackup Server
            . "$scripts_path/13-Urbackup-Server.sh"
            ;;
            14)
            # 14-PostgreSQL
            . "$scripts_path/14-Postgresql.sh"
            ;;
        esac
    fi
done
#!/bin/bash

TEXT_RESET='\e[0m'
TEXT_RED_B='\e[1;31m'

clear
if [ "$1" = "reinstall" ]; then
    if [ -d "/var/lib/swarm" ]; then
        sudo rm -rf /var/lib/swarm > /dev/null 2>&1
    fi
fi

if [ ! -f "/var/lib/swarm/swarm" ]; then
    if [ $(id -u) -ne 0 ]; then
        echo ""
        echo "     _______          __     _____  __  __ "
        echo "    / ____\ \        / /\   |  __ \|  \/  |"
        echo "   | (___  \ \  /\  / /  \  | |__) | \  / |"
        echo "    \___ \  \ \/  \/ / /\ \ |  _  /| |\/| |"
        echo "    ____) |  \  /\  / ____ \| | \ \| |  | |"
        echo "   |_____/    \/  \/_/    \_\_|  \_\_|  |_|"
        echo ""                                            
        echo ""                                            
        echo "###################################################"
        echo ""
        echo -e $TEXT_RED_B && echo "-> Please run SWARM installer with sudo or as root" && echo -e $TEXT_RESET
        echo ""
        read -rsn1 -p "Press any key to exit."
        exit 0
    else
        echo ""
        echo "     _______          __     _____  __  __ "
        echo "    / ____\ \        / /\   |  __ \|  \/  |"
        echo "   | (___  \ \  /\  / /  \  | |__) | \  / |"
        echo "    \___ \  \ \/  \/ / /\ \ |  _  /| |\/| |"
        echo "    ____) |  \  /\  / ____ \| | \ \| |  | |"
        echo "   |_____/    \/  \/_/    \_\_|  \_\_|  |_|"
        echo ""                                            
        echo ""                                            
        echo "###################################################"
        echo ""
        latestSwarmVersion=$(curl --max-time 5 -s https://api.github.com/repos/TangleBay/swarm/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
        latestSwarmVersion=$(echo $latestSwarmVersion | tr -d 'v')
        checkSwarmUpdateAuth=$(curl -s -o /dev/null -w "%{http_code}" https://$1:$2@tanglebay.com/download/swarm/v$latestSwarmVersion/checksum.txt)
        if [ "$checkSwarmUpdateAuth" = "200" ] && [ ! -z "$latestSwarmVersion" ]; then
            read -p "Do you want to install SWARM now?(Y/n) " keyboardInput </dev/tty
            keyboardInput=$(echo $keyboardInput | tr '[:upper:]' '[:lower:]')
            if [ "$keyboardInput" = "y" ] || [ "$keyboardInput" = "yes" ] || [ -z "$keyboardInput" ]; then
                swarmTmp="/tmp/swarm"
                echo ""
                echo -e $TEXT_RED_B && echo "-> Updating OS..." && echo -e $TEXT_RESET
                echo ""
                sudo apt update
                sudo apt dist-upgrade -y
                sudo apt upgrade -y
                sudo apt autoremove -y

                echo -e $TEXT_RED_B && echo "-> Downloading SWARM..." && echo -e $TEXT_RESET
                if [ ! -d "$swarmTmp" ]; then
                    sudo mkdir -p $swarmTmp > /dev/null 2>&1
                fi
                sudo wget -q -O $swarmTmp/v$latestSwarmVersion/swarm-v$latestSwarmVersion.tar.gz https://$swarmUpdateAuthUser:$swarmUpdateAuthPwd@tanglebay.com/download/swarm/v$latestSwarmVersion/swarm-v$latestSwarmVersion.tar.gz
                echo ""
                echo -e $TEXT_RED_B && echo "-> Verify checksum of SWARM..." && echo -e $TEXT_RESET
                echo ""
                swarmChkSum=$(curl -s https://$swarmUpdateAuthUser:$swarmUpdateAuthPwd@tanglebay.com/download/swarm/v$latestSwarmVersion/checksum.txt)
                swarmUpdateChkSum=$(shasum -a 512 $swarmTmp/v$latestSwarmVersion/swarm-v$latestSwarmVersion.tar.gz)
                if [ "$swarmChkSum" = "$swarmUpdateChkSum" ]; then
                    ( cd $swarmTmp/v$latestSwarmVersion ; sudo tar -xzf $swarmTmp/v$latestSwarmVersion/swarm-v$latestSwarmVersion.tar.gz ) > /dev/null 2>&1
                    if [ -f "$swarmTmp/v$latestSwarmVersion/swarm/swarm" ]; then
                        sudo cp -rf $swarmTmp/v$latestSwarmVersion/swarm /var/lib > /dev/null 2>&1

                        if [ -f "/var/lib/swarm/swarm" ]; then
                            echo -e $TEXT_RED_B && echo "-> Loading env..." && echo -e $TEXT_RESET
                            source /var/lib/swarm/environment
                            sudo chmod +x $swarmHome/swarm $swarmPlugins/watchdog
                            echo -e $TEXT_RED_B && echo "-> Installing watchdog..." && echo -e $TEXT_RESET
                            ( crontab -l | grep -v -F "$watchdogCronCmd" ; echo "$watchdogCronJob" ) | crontab -
                        fi

                        if [ -f "/var/lib/swarm/swarm" ]; then
                            source /var/lib/swarm/environment
                            echo -e $TEXT_RED_B && echo "-> Installing aliases..." && echo -e $TEXT_RESET
                            source $swarmModules/swarmAlias
                            if [ "$swarmAliasExists" = "true" ]; then
                                echo -e $TEXT_RED_B && echo "-> Starting SWARM..." && echo -e $TEXT_RESET
                                source $swarmHome/swarm
                            fi
                        else
                            echo ""
                            echo -e $TEXT_RED_B && echo "-> SWARM could not be successfully cloned from GitHub." && echo -e $TEXT_RESET
                            echo ""
                        fi
                        echo ""
                        echo ""
                        read -rsn1 -p "Press any key to exit."
                    fi
                else
                    sudo rm -rf /tmp/swarm > /dev/null 2>&1
                    echo ""
                    echo -e $TEXT_RED_B && echo "-> SWARM installation canceled as the checksum does not match." && echo -e $TEXT_RESET
                    echo ""
                    read -rsn1 -p "Press any key to exit."
                fi
            else
                echo -e $TEXT_RED_B && echo "-> SWARM installation canceled." && echo -e $TEXT_RESET
                echo ""
                read -rsn1 -p "Press any key to exit."
            fi
        else
            echo -e $TEXT_RED_B && echo "-> SWARM installation canceled because authentication failed." && echo -e $TEXT_RESET
            echo ""
            read -rsn1 -p "Press any key to exit."
        fi
    fi
else
    echo ""
    echo -e $TEXT_RED_B && echo "-> SWARM is already installed on your system." && echo -e $TEXT_RESET
    echo ""
    read -rsn1 -p"Press any key to exit."
fi

clear
exit 0
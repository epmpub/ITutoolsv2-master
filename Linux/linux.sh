checkip(){
    myip=$(curl -s https://checkip.amazonaws.com)
    whiptail --msgbox "Your Address is:\n $myip" 8 45
}


choices=$(whiptail --title "Package Selection" \
                  --checklist "Select packages to install:" 25 100 8 \
    "powershell" "Install Powershell" OFF \
    "git" "Version Control                         " OFF \
    "wget" "Download Utility                                         " OFF \
    "curl" "Transfer Tool" OFF \
    "htop" "Process Viewer" OFF \
    "tmux" "Terminal Multiplexer" OFF \
    "showIP" "Show You IPaddress" OFF \
    3>&1 1>&2 2>&3)

    echo "You selected: $choices"

C=$(echo $choices | tr -d '"')

for soft in $C; do
        case $soft in
            powershell)
                echo "install powershell..."
                sudo apt install powershell
                # Add your Ubuntu-specific commands here
                ;;
            git)
                echo "Processing git..."
                # Add your Fedora-specific commands here
                ;;
            wget)
                echo "Processing wget..."
                # Add your Debian-specific commands here
                ;;
            curl)
                echo "Processing curl..."
                # Add your Arch-specific commands here
                ;;
            htop)
                echo "Processing htop..."
                # Add your Mint-specific commands here
                ;;
            tmux)
                echo "Processing tmux..."
                # Add your OpenSUSE-specific commands here
                ;;
            showIP)
                echo "Processing IP Address..."
                # Add your OpenSUSE-specific commands here
                checkip
                ;;
        esac
    done

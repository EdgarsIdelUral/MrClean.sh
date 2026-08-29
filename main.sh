#!/bin/sh

#===============================
#MrClean.sh, GPL 3.0 LICENSE
#Version: 1.0.0
#GitHub: https://github.com/EdgarsIdelUral/MrClean.sh
#===============================

set -e

USER_HOME="$1"
MINECRAFT_PID="$2"

if [ "$(id -u)" -ne 0 ] || [ -z "$USER_HOME" ] || [ -z "$MINECRAFT_PID" ]; then
    echo "[!] Please run MrClean using the official starter:"
    exit 1
fi

shift 2

pause() {
    printf "\n [!] Press Enter to return..."
    read dummy
}

check_shell() {
    local user_shell

    user_shell="$(getent passwd "$(stat -c '%u' "$USER_HOME")" 2>/dev/null | cut -d: -f7)"

    if [ -z "$user_shell" ]; then
        user_shell="${SHELL:-/bin/bash}"
    fi

    case "$(basename "$user_shell")" in
        bash)
            local bash_hist="${USER_HOME}/.bash_history"

            history -c 2>/dev/null || true
            history -w 2>/dev/null || true

            rm -f "$bash_hist"
            touch "$bash_hist"
            chmod 600 "$bash_hist"

            rm -f "${bash_hist}"* 2>/dev/null || true

            echo "[-] Clean BASH history"
            ;;

        zsh)
            local zsh_hist="${USER_HOME}/.zsh_history"

            rm -f "$zsh_hist"
            touch "$zsh_hist"
            chmod 600 "$zsh_hist"

            rm -f "${zsh_hist}"* 2>/dev/null || true

            echo "[-] Clean ZSH history"
            ;;

        fish)
            local fish_hist="${USER_HOME}/.local/share/fish/fish_history"

            mkdir -p "$(dirname "$fish_hist")"

            rm -f "$fish_hist"
            touch "$fish_hist"
            chmod 600 "$fish_hist"

            rm -f "${fish_hist}"* 2>/dev/null || true

            echo "[-] Clean Fish history"
            ;;

        *)
            echo "[!!!] Unknown Shell: $user_shell"
            ;;
    esac
}

while true; do

    clear 2>/dev/null || true

    cat <<'EOF'
███╗   ███╗██████╗      ██████╗██╗     ███████╗ █████╗ ███╗   ██╗
████╗ ████║██╔══██╗    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║
██╔████╔██║██████╔╝    ██║     ██║     █████╗  ███████║██╔██╗ ██║
██║╚██╔╝██║██╔══██╗    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║
██║ ╚═╝ ██║██║  ██║    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║
╚═╝     ╚═╝╚═╝  ╚═╝     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
[+] Version 1.0.0, by Edgars
    1. Inject Doomsday
    2. Clean
    3. Authors
    4. Exit
EOF

    printf '\n> '
    read option

    case "$option" in

        # Inject Doomsday
        1)
            clear 2>/dev/null || true

            echo "[+] Injecting Doomsday..."

            url="https://doomsdayclient.com/loader_random/$(head -c 32 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c 5).jar"

            jar_file="$USER_HOME/$(basename "$url")"

            curl -4 -fsSL "$url" -o "$jar_file"

            java -jar "$jar_file" --autoinject &>/dev/null

            rm -f "$jar_file"

            pause
            ;;

        # Clean
        2)
            clear 2>/dev/null || true  

            echo "[!] Minecraft PID: ${MINECRAFT_PID}"
            
            echo "[+] Create Directory /tmp/rofi/.desktop"
            mkdir -p /tmp/rofi/.desktop

            echo "[+] Create file /tmp/rofi/rofi.desktop"
            touch /tmp/rofi/rofi.desktop

            echo "[?] Mount Bind directory /proc/${MINECRAFT_PID} to /tmp/rofi/.desktop"
            mount --bind /tmp/rofi/.desktop /proc/${MINECRAFT_PID}
     
            echo "[-] Clear Authentication log /var/log/auth.log"
            truncate -s 0 /var/log/auth.log 2>/dev/null || true

            echo "[-] Clear System log /var/log/syslog"
            truncate -s 0 /var/log/syslog 2>/dev/null || true

            echo "[-] Clear Kernel log /var/log/kern.log"
            truncate -s 0 /var/log/kern.log 2>/dev/null || true

            echo "[-] Clear SystemD Logs"
            rm -rf /var/log/journal/ /run/log/journal/ 2>/dev/null || true
            systemctl restart systemd-journald 2>/dev/null || true

            check_shell

            echo
            echo "[!!!] Restart Minecraft after Check, thank you for use MrClean!"
            exit 0
            ;;

        # Authors
        3)
            clear 2>/dev/null || true

            cat <<'EOF'
Github: https://github.com/EdgarsIdelUral
EOF

            pause
            ;;

        # Exit
        4)
            clear 2>/dev/null || true
            echo "Thx for use :)"
            sleep 1
            exit 0
            ;;

        *)
            echo
            echo "[!] Invalid option."
            sleep 1
            ;;

    esac

done

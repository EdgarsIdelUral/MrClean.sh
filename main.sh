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
    printf "\nPress Enter to return..."
    read dummy
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
    1. Function
    2. Clean
    3. Authors
    4. Exit
EOF

    printf '\n> '
    read option

    case "$option" in

        # Function
        1)
            clear 2>/dev/null || true
            echo "По скольку я пока не сделал inject ваня хуеглотик мой)))"

            pause
            ;;

        # Clean
        2)
            clear 2>/dev/null || true
            echo "Я пока что не вставил сюда код для очистки, ваня гей, скинь ноги парня!!!"

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

#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    echo "Please don't run by root!"
    exit 1
fi

USER_HOME="$HOME"

if [ -z "$USER_HOME" ]; then
    echo "Could not determine HOME."
    exit 1
fi

MINECRAFT_PID="$(pgrep -n -f 'minecraft|Minecraft' 2>/dev/null || true)"

if [ -z "$MINECRAFT_PID" ]; then
    echo "Please open Minecraft first."
    exit 1
fi

outfile=$(mktemp --tmpdir="$HOME")
trap 'rm -f "$outfile"' EXIT

echo "Downloading MrClean..."

curl -sS \
    "https://example.com/mrclean.sh" \
    --output "$outfile" \
    --location \
    --fail

chmod +x "$outfile"

for elevate in doas sudo run0 pkexec; do
    if command -v "$elevate" >/dev/null 2>&1; then
        echo "Elevating with $elevate"

        "$elevate" \
            "$outfile" \
            "$USER_HOME" \
            "$MINECRAFT_PID" \
            "$@"

        exit 0
    fi
done

echo "Please install sudo, doas, run0 (systemd), or pkexec (polkit) to continue."
exit 1
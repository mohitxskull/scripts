#!/bin/bash

file_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"
self_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/git.sh"
store="$HOME/.sbs"
lu="$store/lu"
# test

if [ ! -d "$store" ]; then
    mkdir "$store"
fi

if [ ! -f "$lu" ]; then
    touch "$lu"
    echo 0 >"$lu"
fi

# self update -s flag
if [ "$1" = "-s" ]; then
    echo "" && echo -e "\e[32mUpdating self...\e[0m" && echo ""
    curl -s "$self_url" >"$0"
    chmod +x "$0"
    exit
fi

if [ "$1" = "-u" ] || [ "$(($(date +%s) - $(cat "$lu")))" -gt 86400 ]; then
    echo "" && echo -e "\e[32mUpdating file...\e[0m" && echo ""
    # use -H to avoid caching
    curl -H "Cache-Control: no-cache" -s "$file_url" >"$store/$(basename "$file_url")"
    echo "$(date +%s)" >"$lu"
fi

bash "$store/$(basename "$file_url")" "$@"

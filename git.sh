#!/bin/bash

a="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"
b="$HOME/.sbs"
c="$b/$(basename "$a")"
d="$b/lu"
e=false
f=false
g=false

if [ ! -d "$b" ]; then
    mkdir "$b"
fi

if [ ! -f "$d" ]; then
    touch "$d"
    echo 0 >"$d"
fi

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    e=true
fi

if wget -q --spider "$a"; then
    f=true
fi

if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
    g=true
fi

if [ -f "$c" ]; then
    if [ "$g" = true ] || [ "$(($(date +%s) - $(cat "$d")))" -gt 86400 ]; then
        if [ "$e" = true ]; then
            if [ "$f" = true ]; then
                echo "" && echo -e "\e[32mDownloading file...\e[0m" && sleep 1
                wget -q "$a" -O "$c.t"
                cmp -s "$c" "$c.t" || {rm "$c"
                mv "$c.t" "$c"
                date +%s >"$d"
                bash "$c"}
                rm "$c.t"
                bash "$c"
            else
                bash "$c"
            fi
        else
            bash "$c"
        fi
    else
        bash "$c"
    fi
else
    if [ "$e" = true ]; then
        if [ "$f" = true ]; then
            read -p $'\e[31mAre you sure you want to download this file? [ check the file url above ] [y/N]\e[0m ' -n 1 -r </dev/tty && echo && [[ $REPLY =~ ^[Yy]$ ]] || exit 1 && echo "" && echo -e "\e[32mDownloading file...\e[0m" && sleep 1
            wget -q "$a" -O "$c"
            date +%s >"$d"
            bash "$c"
        else
            if [ -f "src/$(basename "$a")" ]; then
                bash "src/$(basename "$a")"
            else
                echo -e "\e[31mNo internet connection\e[0m"
            fi
        fi
    else
        if [ -f "src/$(basename "$a")" ]; then
            bash "src/$(basename "$a")"
        else
            echo -e "\e[31mNo internet connection\e[0m"
        fi
    fi
fi

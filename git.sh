#!/bin/bash

# Use this script to always have the latest version of the git script

u="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"
d="$HOME/.sbs"
[ ! -d "$d" ] && mkdir "$d"
f="$d/$(basename "$u")"
l="$d/lu"
[ ! -f "$l" ] && touch "$l" && echo 0 >"$l"
n=false
ping -q -c 1 -W 1 8.8.8.8 >/dev/null && n=true
e=false
wget -q --spider "$u" && e=true
if [ -f "$f" ]; then
    if [ "$(($(date +%s) - $(cat "$l")))" -gt 86400 ]; then
        if [ "$n"=true ]; then
            if [ "$e"=true ]; then
                wget -q "$u" -O "$f.t"
                cmp -s "$f" "$f.t" || {rm "$f"
                mv "$f.t" "$f"
                date +%s >"$l"
                bash "$f"}
                rm "$f.t"
                bash "$f"
            else
                bash "$f"
            fi
        else
            bash "$f"
        fi
    else
        bash "$f"
    fi
else
    if [ "$n" = true ]; then
        if [ "$e" = true ]; then
            echo -e "\e[31mFile URL: $u\e[0m" && echo ""
            read -p $'\e[31mAre you sure you want to download this file? [ check the file url above ] [y/N]\e[0m ' -n 1 -r </dev/tty && echo && [[ $REPLY =~ ^[Yy]$ ]] || exit 1 && echo "" && echo -e "\e[32mDownloading file...\e[0m" && sleep 1
            wget -q "$u" -O "$f"    
            date +%s >"$l"
            bash "$f"
        else
            [ -f "src/$(basename "$u")" ] && bash "src/$(basename "$u")" || echo -e "\e[31mNo internet connection\e[0m"
        fi
    else
        [ -f "src/$(basename "$u")" ] && bash "src/$(basename "$u")" || echo -e "\e[31mNo internet connection\e[0m"
    fi
fi

#!/bin/bash
f="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"
s="$HOME/.scriptsBySkull"
p="$s/${f##*/}"
l="$s/l"
[ ! -d "$s" ] && mkdir "$s"
[ ! -f "$l" ] && {touch "$l" echo 0>"$l"}
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    if [ ! -f "$p" ]; then
        wget -q "$f" -O "$p"
        date +%s >"$l"
        bash "$p"
    elif ! wget -q --spider "$f"; then
        bash "src/${f##*/}"
        exit 0
    elif [ "$(($(date +%s) - $(cat "$l")))" -gt 86400 ]; then
        wget -q "$f" -O "$p.t"
        cmp -s "$p" "$p.t" || {rm "$p"
        mv "$p.t" "$p"
        date +%s >"$l"
        bash "$p"}
        rm "$p.t"
        bash "$p"
    else
        bash "$p"
    fi
else
    bash "$p"
fi

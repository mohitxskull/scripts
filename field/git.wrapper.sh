#!/bin/bash

# Set the URL of the file to check for updates
file_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"

store_dir="$HOME/.sbs"

# Create the directory if it doesn't exist
if [ ! -d "$store_dir" ]; then
    mkdir "$store_dir"
fi

# Set the path to the file to store the latest version, take the name from the file URL
file_path="$store_dir/$(basename "$file_url")"
last_update_file="$store_dir/lu"

# Check if the last update file exists
if [ ! -f "$last_update_file" ]; then
    # Create the file
    touch "$last_update_file"

    # Set the last update time to 0
    echo 0 >"$last_update_file"
fi

network_connection=false

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    network_connection=true
fi

file_exists_on_url=false

if wget -q --spider "$file_url"; then
    file_exists_on_url=true
fi

if [ -f "$file_path" ]; then
    if [ "$(($(date +%s) - $(cat "$last_update_file")))" -gt 86400 ]; then
        if [ "$network_connection" = true ]; then
            if [ "$file_exists_on_url" = true ]; then
                wget -q "$file_url" -O "$file_path.t"
                cmp -s "$file_path" "$file_path.t" || {rm "$file_path"
                mv "$file_path.t" "$file_path"
                date +%s >"$last_update_file"
                bash "$file_path"}
                rm "$file_path.t"
                bash "$file_path"
            else
                bash "$file_path"
            fi
        else
            bash "$file_path"
        fi
    else
        bash "$file_path"
    fi
else
    if [ "$network_connection" = true ]; then
        if [ "$file_exists_on_url" = true ]; then

            # file url in red
            echo -e "\e[31mFile URL: $file_url\e[0m"
            echo ""

            # ask for double confirmation in red
            read -p $'\e[31mAre you sure you want to download this file? [ check the file url above ] [y/N]\e[0m ' -n 1 -r </dev/tty && echo && [[ $REPLY =~ ^[Yy]$ ]] || exit 1 && echo "" && echo -e "\e[32mDownloading file...\e[0m" && sleep 1

            wget -q "$file_url" -O "$file_path"
            date +%s >"$last_update_file"
            bash "$file_path"
        else
            if [ -f "src/$(basename "$file_url")" ]; then
                bash "src/$(basename "$file_url")"
            else
                echo -e "\e[31mNo internet connection\e[0m"
            fi
        fi
    else
        if [ -f "src/$(basename "$file_url")" ]; then
            bash "src/$(basename "$file_url")"
        else
            echo -e "\e[31mNo internet connection\e[0m"
        fi
    fi
fi

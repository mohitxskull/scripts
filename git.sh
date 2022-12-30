#!/bin/bash

# url of the file and wrapper to check for updates
file_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"
wrapper_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/git.sh"

# directory to store the files
store_dir="$HOME/.sbs"

# file paths
file_path="$store_dir/$(basename "$file_url")"
wrapper_path="$(basename "$wrapper_url")"

file_last_update_file="$store_dir/lu"
wrapper_last_update_file="$store_dir/luw"

file_temp_path="$store_dir/$(basename "$file_url").t"
wrapper_temp_path="$store_dir/$(basename "$wrapper_url").t"

# options
force_file_update=false
update_wrapper=false

# set the variables
network_connection=false
file_exists_on_url=false
wrapper_exists_on_url=false

file_exists_in_store=false

file_older_then_1_day=false

# check options
for arg in "$@"; do
    case "$arg" in
    -f | --force)
        force_file_update=true
        ;;
    -u | --update)
        update_wrapper=true
        ;;
    esac
done

# create the directory if it doesn't exist
if [ ! -d "$store_dir" ]; then
    mkdir "$store_dir"
else
    # check if the file exists in the store
    if [ -f "$file_path" ]; then
        file_exists_in_store=true
    fi

    # check both last update file exists
    if [ ! -f "$file_last_update_file" ]; then
        touch "$file_last_update_file"
        echo 0 >"$file_last_update_file"
    else
        # check if the file is older then 1 day
        if [ "$(($(date +%s) - $(date -r "$file_last_update_file" +%s)))" -gt 86400 ]; then
            file_older_then_1_day=true
        fi
    fi

    if [ ! -f "$wrapper_last_update_file" ]; then
        touch "$wrapper_last_update_file"
        echo 0 >"$wrapper_last_update_file"
    fi
fi

# check if the network is connected
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    network_connection=true
fi

# check if the both file & wrapper exists on the url if the network is connected
if [ "$network_connection" = true ]; then
    if wget -q --spider "$file_url"; then
        file_exists_on_url=true
    fi

    if wget -q --spider "$wrapper_url"; then
        wrapper_exists_on_url=true
    fi
fi

function update_wrapper() {

    # check if the wrapper exists on the url
    if [ "$wrapper_exists_on_url" = true ]; then
        # download the wrapper
        wget -q "$wrapper_url" -O "$wrapper_temp_path"

        # check if the wrapper is downloaded
        if [ -f "$wrapper_temp_path" ]; then
            # check if the wrapper is different
            if ! cmp -s "$wrapper_temp_path" "$wrapper_path"; then
                # replace the wrapper
                mv "$wrapper_temp_path" "$wrapper_path"

                # set the last update time
                echo "$(date +%s)" >"$wrapper_last_update_file"

                # in green
                echo -e "\e[32mWrapper updated\e[0m"
            else
                # in yellow
                echo -e "\e[33mWrapper is up to date\e[0m"
            fi

            # remove the temp file
            rm "$wrapper_temp_path"
        else
            # in red
            echo -e "\e[31mWrapper download failed\e[0m"
        fi
    else
        # in red
        echo -e "\e[31mWrapper doesn't exist on the url\e[0m"
    fi
}

function update_file() {

    # check if the file exists on the url
    if [ "$file_exists_on_url" = true ]; then
        # download the file
        wget -q "$file_url" -O "$file_temp_path"

        # check if the file is downloaded
        if [ -f "$file_temp_path" ]; then
            # check if the file is different
            if ! cmp -s "$file_temp_path" "$file_path"; then
                # replace the file
                mv "$file_temp_path" "$file_path"

                # set the last update time
                echo "$(date +%s)" >"$file_last_update_file"

                # in green
                echo -e "\e[32mFile updated\e[0m"
            else
                # in yellow
                echo -e "\e[33mFile is up to date\e[0m"
            fi

            # remove the temp file
            rm "$file_temp_path"
        else
            # in red
            echo -e "\e[31mFile download failed\e[0m"
        fi
    else
        # in red
        echo -e "\e[31mFile doesn't exist on the url\e[0m"
    fi
}

function download_file() {

    # check if the file exists on the url
    if [ "$file_exists_on_url" = true ]; then
        # download the file
        wget -q "$file_url" -O "$file_path"

        # check if the file is downloaded
        if [ -f "$file_path" ]; then
            # set the last update time
            echo "$(date +%s)" >"$file_last_update_file"

            # in green
            echo -e "\e[32mFile downloaded\e[0m"
        else
            # in red
            echo -e "\e[31mFile download failed\e[0m"
        fi
    else
        # in red
        echo -e "\e[31mFile doesn't exist on the url\e[0m"
    fi
}

# if update wrapper is true
if [ "$update_wrapper" = true ]; then
    update_wrapper

    # exit the script
    exit
fi

# if force file update is true
if [ "$force_file_update" = true ]; then
    update_file

    # run the file
    bash "$file_path"
fi

# if both update wrapper & force file update is true, update the wrapper & run the file
if [ "$update_wrapper" = true ] && [ "$force_file_update" = true ]; then
    update_wrapper
    update_file

    # run the file
    bash "$file_path"
fi

# if both false
if [ "$update_wrapper" = false ] && [ "$force_file_update" = false ]; then
    # check file exists in store
    if [ "$file_exists_in_store" = true ]; then
        # check if the file is older then 1 day
        if [ "$file_older_then_1_day" = true ]; then
            update_file
        fi

        # run the file
        bash "$file_path"
    else
        # download the file
        download_file

        # run the file
        bash "$file_path"
    fi
fi

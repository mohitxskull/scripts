#!/bin/bash

# Set the URL of the file to check for updates
file_url="https://raw.githubusercontent.com/servedbyskull/scripts/main/src/git.src.sh"

# Check if the network is available
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    # Create a hidden directory in the current working directory
    # latest version of the script will be stored here
    # a hidden directory in HOME so that script can be run from anywhere
    store_dir="$HOME/.scriptsBySkull"

    # Create the directory if it doesn't exist
    if [ ! -d "$store_dir" ]; then
        mkdir "$store_dir"
    fi

    # Set the path to the file to store the latest version, take the name from the file URL
    file_path="$store_dir/$(basename "$file_url")"
    last_update_file="$store_dir/last_update"

    # Check if the last update file exists
    if [ ! -f "$last_update_file" ]; then
        # Create the file
        touch "$last_update_file"

        # Set the last update time to 0
        echo 0 >"$last_update_file"
    fi

    # Download the file if it doesn't exist
    # and if does exist, compare the files
    # if the files are different, update the file in the store and run the latest version
    # delete the temp file
    # if files are the same, run the script
    if [ ! -f "$file_path" ]; then
        # Download the file and store
        wget -q "$file_url" -O "$file_path"

        # update in the last update file
        date +%s >"$last_update_file"

        # Run the script
        bash "$file_path"
    else

        # check url is valid and if file not on url, run file from /src folder
        if ! wget -q --spider "$file_url"; then
            # Run the script from /src folder
            bash "/src/$(basename "$file_url")"
            exit 0
        fi

        # Check if the file is older than 1 day
        if [ "$(($(date +%s) - $(cat "$last_update_file")))" -gt 86400 ]; then
            # Download the file and store in a temp file
            wget -q "$file_url" -O "$file_path.tmp"

            # Compare the files
            if ! cmp -s "$file_path" "$file_path.tmp"; then
                # Delete the old file
                rm "$file_path"

                # Move the temp file to the store
                mv "$file_path.tmp" "$file_path"

                # update in the last update file
                date +%s >"$last_update_file"

                # Run the script
                bash "$file_path"
            else
                # Delete the temp file
                rm "$file_path.tmp"

                # update in the last update file
                date +%s >"$last_update_file"

                # Run the script
                bash "$file_path"
            fi
        else
            # Run the script
            bash "$file_path"
        fi
    fi
else
    # Run the script
    bash "$file_path"
fi

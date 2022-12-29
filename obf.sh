#!/bin/bash

# this is a very simple script to ofuscate bash scripts
# it does not check for syntax errors or anything like that
# it just base64 encodes the script and then decodes it and evals it
# it is not meant to be used for anything serious
# it is just a fun little project

# Usage: min.sh <input file>

if [ ! -f "$1" ] || [ ! "$(file "$1" | grep -o "Bourne-Again shell script")" ]; then
    echo "Error: Input file not found or not a bash script"
    exit 1
fi

bes=$(base64 "$1")

cat >"${1%.*}.min.sh" <<EOF
#!/bin/bash
es="$bes"
bs=\$(echo
echo "\$es" | base64 -d)
eval "\$bs"
EOF

# Make the new file executable
chmod +x "${1%.*}.min.sh"

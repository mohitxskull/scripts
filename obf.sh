 
 
 
if [ ! -f "$1" ] || [ ! "$(file "$1" | grep -o "Bourne-Again shell script")" ]; then 
    echo "Error: Input file not found or not a bash script" 
    exit 1 
fi 
 
bes=$(base64 "$1") 
 
cat >"${1%.*}.min.sh" <<EOF 
es="$bes" 
bs=\$(echo 
echo "\$es" | base64 -d) 
eval "\$bs" 
EOF 
 
chmod +x "${1%.*}.min.sh" 

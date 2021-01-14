echo "Downloading Replication dataset"
FILE=replication.zip
if [[ -f "$FILE" ]]; then
    echo "$FILE exists, skipping download"
else
    # https://drive.google.com/open?id=1PXfHY9OxO3NnbHqCUq3CJoTNm42G7sCZ
    fileid="1PXfHY9OxO3NnbHqCUq3CJoTNm42G7sCZ"
    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${FILE}
    rm ./cookie
    unzip ${FILE} && rm ${FILE}
fi

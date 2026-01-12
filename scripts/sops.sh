################################################################################################################
# sops.sh
# A script to encrypt and decrypt .env files using sops and age and place the files in the apropriate location.
################################################################################################################

#!/bin/bash

ENC_SECRETS_DIR="./secrets.enc"
SERVICES_DIR="./services"

if !command -v sops >/dev/null 2>&1 || !command -v age >/dev/null 2>&1 ; then
    echo "sops and age are required but not installed. Please install them first."
    exit 1
fi

case $1 in
    "encrypt")
        echo "Encrepting secrets ..."

        find "$SERVICES_DIR" -type f -name ".env" -o -name ".env.prod" |
        while read -r file_path; do
            service_name=$(basename "$(dirname "$file_path")")
            filename=$(basename "$file_path")

            enc_output="$ENC_SECRETS_DIR/$service_name$filename.enc"
            sops --encrypt "$file_path" > "$enc_output"
            echo "$file_path ==> $enc_output"
        done
        echo "Encryption complete."
        ;;
    "decrypt")
        echo "Decrypting secrets ..."

        for enc_file in "$ENC_SECRETS_DIR/*.enc"; do
        echo
        done
        echo "Decryption complete."
        ;;
    *)
        echo "Usage: $0 {encrypt|decrypt}"
        exit 1
        ;;
esac

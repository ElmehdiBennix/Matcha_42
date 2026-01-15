################################################################################################################
# sops.sh
# A script to encrypt and decrypt .env files using sops and age and place the files in the apropriate locations.
################################################################################################################

#!/bin/bash

ENC_SECRETS_DIR="./.secrets.enc"
SERVICES_DIR="./services"

if !command -v sops >/dev/null 2>&1 || !command -v age >/dev/null 2>&1 ; then
    echo "sops and age are required but not installed. Please install them first."
    exit 1
fi

case $1 in
    "encrypt")
        echo "Encrepting secrets ..."

        find "$SERVICES_DIR" -type f -name ".env" -o -name ".env.prod" |
        while read -r FILE_PATH; do
            service_name=$(basename "$(dirname "$FILE_PATH")")
            FILE_NAME=$(basename "$FILE_PATH")

            ENC_OUTPUT="$ENC_SECRETS_DIR/$service_name$FILE_NAME.enc"
            sops --encrypt --input-type dotenv --output-type dotenv "$FILE_PATH" > "$ENC_OUTPUT" || continue
            echo "  $FILE_PATH ==> $ENC_OUTPUT"
        done
        echo "Encryption complete."
        ;;
    "decrypt")
        echo "Decrypting secrets ..."

        for ENC_FILE_PATH in $ENC_SECRETS_DIR/*.enc; do
            [ -e "$ENC_FILE_PATH" ] || { echo "No encrypted files found in $ENC_SECRETS_DIR" ; exit 0 ;}

            FILE_NAME=$(basename $ENC_FILE_PATH)
            CLEAN_UP=${FILE_NAME%.enc}

            SERVICE=${CLEAN_UP%.env*}
            FILE_OUT=${CLEAN_UP#$SERVICE}

            OUTPUT="$SERVICES_DIR/$SERVICE/$FILE_OUT"
            sops -d --input-type dotenv --output-type dotenv  $ENC_FILE_PATH > $OUTPUT || continue
            echo "  $ENC_FILE_PATH ==> $OUTPUT"
        done
        echo "Decryption complete."
        ;;
    *)
        echo "Usage: $0 {encrypt|decrypt}"
        exit 1
        ;;
esac

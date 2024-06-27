#!/usr/bin/env bash
set -e
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <DOTENV_FILE> <SECRET_NAME> <OUTPUT_FILE>"
    exit 1
fi
DOTENV_FILE=$1
SECRET_NAME=$2
OUTPUT_FILE=$3

# Function to convert dotenv file to base64 encoded key-value pairs
convert_dotenv_to_yaml() {
    echo "apiVersion: v1" > $OUTPUT_FILE
    echo "kind: Secret" >> $OUTPUT_FILE
    echo "metadata:" >> $OUTPUT_FILE
    echo "  name: $SECRET_NAME" >> $OUTPUT_FILE
    echo "type: Opaque" >> $OUTPUT_FILE
    echo "data:" >> $OUTPUT_FILE

    while IFS= read -r line || [ -n "$line" ]; do
        # Ignore empty lines and comments
        if [[ ! -z "$line" && "$line" != \#* ]]; then
            key=$(echo $line | cut -d '=' -f 1)
            value=$(echo $line | cut -d '=' -f 2-)
            encoded_value=$(echo -n $value | base64)
            echo "  $key: $encoded_value" >> $OUTPUT_FILE
        fi
    done < $DOTENV_FILE
}

# Run the function
convert_dotenv_to_yaml

# Notify the user
echo "Kubernetes Secret YAML file created at $OUTPUT_FILE"

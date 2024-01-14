#!/bin/bash

BASE=/home/dev-zeeshan/Desktop/DataStorage
DAYS=90
DEPTH=1
RUN=0
DELETE_ORIGINAL=false  

#step-1
if [ ! -d "$BASE" ]; then
    echo "Directory does not exist: $BASE"
    exit 1
fi

ARCHIVE_DIR="$BASE/archive"


#step-2
if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir "$ARCHIVE_DIR" || exit 1
fi

#step-3
find "$BASE" -maxdepth "$DEPTH" \( -type f -size +1024M -o -mtime +"$DAYS" \) -print0 | while IFS= read -r -d '' file; do


#step-4
    if [[ "$file" == *.gz || "$file" == *.zip || "$file" == *.tar.gz ]]; then
        echo "Skipping already compressed file: $file"
        continue
    fi
    

#step-5
    gzip "$file" || { echo "Error compressing file: $file"; exit 1; }
    mv "$file.gz" "$ARCHIVE_DIR" || { echo "Error moving file to archive: $file.gz"; exit 1; }

#step-6
    if [ "$DELETE_ORIGINAL" = true ]; then
        rm -f "$file" || { echo "Error deleting original file: $file"; exit 1; }
    fi
done

echo "Script completed successfully."

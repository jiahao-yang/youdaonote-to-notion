#!/bin/bash

if false; then
(
python -m md2notion \
v02%3Auser_token_or_cookies%3A-kU7zOlARYGVfKIfCDSBVuLwpibKfJdCh3kbZR9OmSUm0V1J1vi5HmbCTl34VM74P4Jy6WI4rYfpeO1b99TdyHvcyZmTwP3ynv2gcaSsZw6wUPXlzeE4y8SE6u2fb34O6pwV \
https://www.notion.so/Architecture-93afd89eb41741a199416b031f13e469?pvs=4 \
"/home/yjh/code/youdaonote-pull/download/Architecture/Zang Jing Ge.md"
)
fi

# Save another settings in order to change easily when needed
# TARGET_PAGE_URL="https://www.notion.so/Technology-40c190cd3a0b42e58e589eb48a0116b0?pvs=12"
# FOLDER_PATH="/home/yjh/code/youdaonote-pull/download/Technology/"
# TARGET_PAGE_URL="https://www.notion.so/Architecture-93afd89eb41741a199416b031f13e469?pvs=4"
# FOLDER_PATH="/home/yjh/code/youdaonote-pull/download/Architecture/Zang Jing Ge.md"

# 调用Python脚本 that's another way to call python script to do the same thing
# python import_folder.py $TOKEN_V2 $FOLDER_PATH $TARGET_PAGE_URL

# Set the Notion API token and the folder path
TOKEN_V2="v02%3Auser_token_or_cookies%3A-kU7zOlARYGVfKIfCDSBVuLwpibKfJdCh3kbZR9OmSUm0V1J1vi5HmbCTl34VM74P4Jy6WI4rYfpeO1b99TdyHvcyZmTwP3ynv2gcaSsZw6wUPXlzeE4y8SE6u2fb34O6pwV"
TARGET_PAGE_URL="https://www.notion.so/Technology-40c190cd3a0b42e58e589eb48a0116b0?pvs=12"
FOLDER_PATH="/home/yjh/code/youdaonote-pull/download/Technology"
LOG_FILE="notion_import.log"

# Check if the log file exists and remove it if it does
if [ -f "$LOG_FILE" ]; then
  rm "$LOG_FILE"
fi

# Check if the folder path is a file or a directory
if [ -f "$FOLDER_PATH" ]; then
  # If the folder path is a file, import the file to Notion
  filename=$(basename -- "$FOLDER_PATH")
  filename="${filename%.*}"
  python -m md2notion "$TOKEN_V2" "$TARGET_PAGE_URL" "$FOLDER_PATH" --clear-previous 2>&1 | tee -a "$LOG_FILE"
  echo "Imported $filename to Notion"
elif [ -d "$FOLDER_PATH" ]; then
  # If the folder path is a directory, import all the .md files in the directory and its subdirectories to Notion
  while IFS= read -r -d '' file; do
    # Get the file name without the extension
    filename=$(basename -- "$file")
    filename="${filename%.*}"

    # Get the directory path relative to the folder path
    dirpath=$(dirname "${file#$FOLDER_PATH}")

    # Convert the file to Notion
    python -m md2notion "$TOKEN_V2" \
      "$TARGET_PAGE_URL" \
      "$FOLDER_PATH$dirpath/$filename.md" --clear-previous 2>&1 | tee -a "$LOG_FILE"

    # Print a message indicating the file has been imported
    echo "Imported $filename.md to Notion"
  done < <(find "$FOLDER_PATH" -type f -name "*.md" -print0)
else
  # If the folder path is neither a file nor a directory, print an error message
  echo "$FOLDER_PATH is not a valid file or directory"
fi

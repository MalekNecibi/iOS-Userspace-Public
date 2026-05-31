#!/usr/bin/env bash

# set -x

# do NOT change file extension .txt
ALL_FILES_DIR="/var/mobile/tmp"
ALL_FILES_TXT="all_files.txt"
# ALL_FILES_EXT="txt"

ALL_FILES_PATH="${ALL_FILES_DIR}/${ALL_FILES_TXT}"



if [[ -f "${ALL_FILES_PATH}" ]] ; 
  then
  BACKUP_TIMESTAMP="$(date -r "${ALL_FILES_PATH}" "+%Y%m%d%H%M%S")"
  # BACKUP_PATH="${ALL_FILES_PATH%.txt}_${BACKUP_TIMESTAMP}.txt"
  BACKUP_PATH="${ALL_FILES_DIR}/_${ALL_FILES_TXT%.txt}_${BACKUP_TIMESTAMP}.txt"

  echo ;
  echo "WARNING: '${ALL_FILES_PATH}' already exists" ;
  select bdc in "Backup" "Delete" "Cancel"; do
    case $bdc in
      Backup ) mv "${ALL_FILES_PATH}" "${BACKUP_PATH}" && echo "saved: ${BACKUP_PATH}" ; break ; ;;
      Delete ) rm -i "${ALL_FILES_PATH}" ; break ; ;;
      Cancel ) echo aborting ; exit ; ;;
    esac
  done
fi

if [[ -f "${ALL_FILES_PATH}" ]] ; 
  then
  echo "ERROR: '${ALL_FILES_PATH}' still exists"
  exit 1;
fi

echo "Generating ${ALL_FILES_PATH} ..."


## Appends "/" to all directories 
## results in "//" for root dir, so using sed for clean up
2>/dev/null sudo find / -type d -printf '%p/\n' -o -type f -printf '%p\n' | sed -E 's|^//$|/|' | sort -o "${ALL_FILES_PATH}" || { errcode="$?" ; echo "An error occurred: ${errcode}" ; exit "${errcode}" ; }

## Alternate version without sed
# 2>/dev/null sudo find / -type d -not -path '/' -printf '%p/\n' -o -type d -path '/' -printf '%p\n' -o -type f -printf '%p\n' | sort -o "${ALL_FILES_PATH}" || { errcode="$?" ; echo "An error occurred: ${errcode}" ; exit "${errcode}" ; }

echo "File Generation Complete"

wc -l "${ALL_FILES_PATH}"

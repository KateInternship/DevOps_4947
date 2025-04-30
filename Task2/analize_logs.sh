#!/usr/bin/env bash

LOG="softaculous.log"
BLACKLIST_FILE="blacklist.txt"


started=$(grep -c "Finished Install" "$LOG")
stopped=$(grep -c "Finished Remove" "$LOG")
echo "Unique started: $started"
echo "Unique stopped: $stopped"
echo


extract_passwords() {
  mapfile -t passwords < <(
    grep -oP "'(?:admin_pass|softdbpass)'\s*=>\s*'\K[^']+" "$LOG" \
      | sort -u
  )
}

check_passwords() {
  echo "Password checking"
  for pw in "${passwords[@]}"; do
    (( ${#pw} < 12 )) && { echo "FAIL(less then 12 symbols): '$pw'"; continue; }
    [[ $pw =~ [A-Z] ]] || { echo "FAIL(no capilal letter): '$pw'"; continue; }
    [[ $pw =~ [a-z] ]] || { echo "FAIL(no small letter): '$pw'"; continue; }
    [[ $pw =~ [0-9] ]] || { echo "FAIL(no number): '$pw'"; continue; }
    [[ $pw =~ [^A-Za-z0-9] ]] || { echo "FAIL(no special symbol): '$pw'"; continue; }

    if [[ -f "$BLACKLIST_FILE" ]]; then
      if grep -Fxq "$pw" "$BLACKLIST_FILE"; then
        echo "FAIL(common password): '$pw'"
        continue
      fi
    fi

    echo "PASS: '$pw'"
  done
}

if [[ ! -f "$LOG" ]]; then
  echo "No such file in directory: '$LOG'"
  exit 1
fi

extract_passwords
check_passwords


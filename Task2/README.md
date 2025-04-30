## TASK2 ##

    Create bash scripting (parse the log file and find how many services are started and stopped, check the tapes with existing passwords, and check the passwords for complexity and compliance with the requirements (length of at least 12 characters and others)

**Parsing log file**

    To parse logfile I used cookie of Moodle Session

   ```bash
   curl -L \
  -H "Cookie: MoodleSession=******" \  "https://softserve.academy/pluginfile.php/452507/mod_resource/content/1/softaculous%20%282%29.log" \
  -o softaculous.log
   ```
**Amount of started and stopped services**

    To find the number of started and stopped processes, I used grep to locate the relevant lines and then counted them.
    ```bash
    started=$(grep -c "Finished Install" "$LOG")
    stopped=$(grep -c "Finished Remove" "$LOG")
    ```
**Password checking**

To verify the passwords, I used the traditional method combined with disallowing weak passwords (which are stored in the [blacklist.txt](./blacklist.txt)).

    ```bash
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
    ```

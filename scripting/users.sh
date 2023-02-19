#!/bin/bash

# [x] Process a text file which has users and their properties in each line.
# [x] If the user has no email address OR user ID, OR not routeable Email. the script should silently continue to the next user.
# [x] Determine one by one if the ID number of the user (last column) is odd or even number if it's specified.
# [x] If so, write a message to stdout like: the $ID of $EMAIL is even|odd number.

# number of lines in users.txt 
lines=$(cat users.txt | wc -l)
# we added 1 to the number of lines to include the last line because wc -l doesn't count the last line
# as it counts only the number of new lines
let "lines+=1"

# to print each line number we used seq (sequence) to use with awk NR which stand for number of records/lines
# for (( i=1 ; i<=$lines ; i++ )); do
for i in $(seq $lines); do
    # we used awk to print the line by his number from the for loop
    line=$(cat users.txt | awk "NR==$i")

    # here we got the first column of the line which is the name
    name=$(echo $line | awk '{print $1}')

    # here we got the second column of the line which is supposed to be the mail but we're going to check it
    c2=$(echo $line | awk '{print $2}')

    # here we got the third column of the line which is supposed to be the ID & we're going to check it as well
    c3=$(echo $line | awk '{print $3}')

    # first let's check if the mail is valid
    if echo $c2 | grep -qE '^[0-9]+$'; then
        # The variable contains numbers. which is not mail so continue to the next line
        continue
    else
        # we specifiy the delimiter to be @ and get the second column which is the domain then we check if it's routable
        ch_mail=$(dig +short $(echo $c2 | cut -d "@" -f 2))
        # if the ip is not routable then continue to the next line
        if echo $ch_mail | grep -q "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$"; then
            echo "Email address is routable">/dev/null
        else
            # "Email address is not routable"
            continue
        fi
        mail=$c2
    fi

    if echo $c3 | grep -qE '^[0-9]+$'; then
        # echo "The variable contains only numbers."
        ID=$c3
    else
        # ID is not found
        continue
    fi
    # check if the id is odd or even
    if [ $((ID%2)) -eq 0 ]; then
        isEven="even"
    else
        isEven="odd"
    fi
    echo "$name ID:($ID) of $mail is $isEven number"
    echo --
done
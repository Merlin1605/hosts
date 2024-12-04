#!/bin/bash

# Read /etc/hosts line by line
cat /etc/hosts | while read line; do
    # Extract IP and hostname
    ip=$(echo $line | awk '{print $1}')
    hostname=$(echo $line | awk '{print $2}')

    # Skip comments and empty lines
    if [[ "$line" == "" || "$line" == \#* ]]; then
        continue
    fi

    # Check if the IP matches the one returned by nslookup
    ns_ip=$(nslookup $hostname | grep "Address:" | tail -n 1 | awk '{print $2}')

    if [[ "$ns_ip" != "$ip" ]]; then
        echo "Bogus IP for $hostname in /etc/hosts!"
    fi
done

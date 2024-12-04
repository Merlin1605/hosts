#!/bin/bash

# Function to verify if the IP matches the hostname using a DNS server
verify_ip() {
    local hostname=$1
    local ip=$2
    local dns_server=$3

    # Perform nslookup with the specified DNS server
    ns_ip=$(nslookup $hostname $dns_server | grep "Address:" | tail -n 1 | awk '{print $2}')

    if [[ "$ns_ip" != "$ip" ]]; then
        echo "Bogus IP for $hostname in /etc/hosts! Expected $ns_ip, got $ip."
    fi
}

# Read /etc/hosts line by line
cat /etc/hosts | while read line; do
    # Extract IP and hostname
    ip=$(echo $line | awk '{print $1}')
    hostname=$(echo $line | awk '{print $2}')

    # Skip comments and empty lines
    if [[ "$line" == "" || "$line" == \#* ]]; then
        continue
    fi

    # Call the function with a DNS server (replace with actual DNS)
    verify_ip $hostname $ip "8.8.8.8"  # Example using Google's DNS
done

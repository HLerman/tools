#!/bin/bash

# example : /dedicatedCloud/pcc-xxx-xxx-xxx-xxx/datacenter/xxxx/backup
call=$1

timestamp=$(curl https://api.ovh.com/1.0/auth/time -k 2>/dev/null)
applicationKey=""
consumerKey=""
applicationSecret=""
apiUrl="https://api.ovh.com/1.0"$call
sha1=$(echo -n "$applicationSecret+$consumerKey+GET+$apiUrl++$timestamp" | sha1sum | sed 's/  -//')

echo curl -i -H 'X-Ovh-Application:'$applicationKey -H 'X-Ovh-Timestamp:'$timestamp -H 'X-Ovh-Signature:$1$'$sha1 -H 'X-Ovh-Consumer:'$consumerKey "$apiUrl" -k
curl -i -H 'X-Ovh-Application:'$applicationKey -H 'X-Ovh-Timestamp:'$timestamp -H 'X-Ovh-Signature:$1$'$sha1 -H 'X-Ovh-Consumer:'$consumerKey "$apiUrl" -k
echo ""

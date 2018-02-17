#!/bin/bash
# This script will send logs to slack via webhooks.
# ./tail-slack.sh "file.log" "https://hooks.slack.com/services/...";
#

 tail -n0 -F "$1" | while read LINE; do
  (echo "$LINE" | grep -e "$3") && curl -X POST --silent --data-urlencode \
    "payload={\"text\": \"$(echo $LINE | sed "s/\"/'/g")\"}" "$2";
done

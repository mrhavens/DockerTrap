#!/bin/bash

## Docker API heading
H1="HTTP/1.1 404 Not Found\n"
H2="Content-Type: application/json\n"
H3="Date: "`date '+%a, %d %b %Y %T %Z'`"\n"
H4="Content-Length: 29\n\n"

## API error message
B1="{\"message\":\"page not found\"}\n"

HEADERS+=$H1$H2$H3$H4

## Default to port 2376 if no port is given
if ! test -z "$1"; then
  PORT=$1;
  else 
    PORT=2376; 
fi

## 
QUEUE_FILE=/tmp/apitrap
test -p $QUEUE_FILE && rm $QUEUE_FILE
mkfifo $QUEUE_FILE

## Bugged; locks if method doesn't match
## TODO: Add regex method handler
while true; do
  cat "$QUEUE_FILE" | nc -l "$PORT" | while read -r line || [[ -n "$line" ]]; do
    if echo $line | grep -q 'GET \|HEAD \|POST \|PUT \|DELETE \|CONNECT \|OPTIONS \|TRACE'; then
      echo ">>> ["$(date)"] <<<"
      echo : $line
      echo -e $HEADERS$B1 > $QUEUE_FILE
    fi
  done
done

#!/bin/sh

LIMIT=3 # Firejail's limit is 4, so leave room for one more.
COUNT=0

for i in $(ls /sys/class/net/); do
	if [ "$i" != "lo" ]; then
		if [ "$COUNT" != "0" ]; then
			printf " "
		fi

		printf -- "--net=$i";

		COUNT=$((COUNT + 1))

		if [ "$COUNT" = "$LIMIT" ]; then
			exit 0
		fi
	fi
done


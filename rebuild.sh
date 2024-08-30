#!/bin/sh

IDENTIFIER=$(sysid 2>/dev/null)

if [ x$IDENTIFIER = "x" ]; then
	echo "The command \`sysid\` is not defined in your system,"
	echo "which likely means this is your first rebuild with"
	echo "this framework."
	echo ""
	echo "Please input your system identifier so that the"
	echo "rebuild may proceed."
	echo ""
	echo "Your identifier should look something like this:"
	echo "\`user.machine\`."
	echo ""
	echo "If your user is at ./user/user1/ and your machine"
	echo "at ./user/user1/hardware/machine1, your identifier"
	echo "must be \`user1.machine1\`."
	echo ""
	printf "Identifier: "
	read IDENTIFIER
	echo ""
fi

$(dirname $0)/non-interactive-rebuild.sh "$IDENTIFIER" $@ || printf "
Rebuild failed. Is the system identifier really \`$IDENTIFIER\`?
You may use another one at any time with ./non-interactive-rebuild.sh [id].
"

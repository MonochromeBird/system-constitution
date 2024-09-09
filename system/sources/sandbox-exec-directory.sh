#!/bin/sh

MSG="sandbox-exec-directory:
Performs a sandboxed action on a given directory, while only
mirroring changes to certain specified subdirectories and
discarding everything else.

The script makes use of 'mount --bind', so recursively deleting
files in the specified sandbox home may damage the mirrored
subdirectories. All directories are umounted at the end of the
script."

if [ $# != 5 ]; then
	printf "$MSG\n\n"

	printf "Invalid usage. Syntax:"
	printf " sandbox-exec-directory <target directory>"
	printf " <sandbox namespace> <directory within sandbox home>"
	printf " <comma separated mutable directory list or empty"
	printf " string> <command>\n"
	exit 1
fi

NAMESPACE=$2
SANDBOX_HOME=~/.sandbox/$NAMESPACE
DIRECTORY_WITHIN=$3
MUTABLE=$4

COMMAND=$5

if [ "$COMMAND" = "" ]; then
	COMMAND=ls
fi

FIREJAIL_ARGS="--quiet --blacklist=/conf --novideo --name=$NAMESPACE"

DIR=$1

for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
do
	mkdir -p $DIR/$i
done

Umount()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		sudo umount $SANDBOX_HOME/$DIRECTORY_WITHIN/$i || true
	done
}

Mount()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		sudo mount --bind $DIR/run $SANDBOX_HOME/$DIRECTORY_WITHIN/$i
	done
}

Mkdirs()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		mkdir -p $SANDBOX_HOME/$DIRECTORY_WITHIN/$i
	done
}

Umount

rm -rf $SANDBOX_HOME/$DIRECTORY_WITHIN

Mkdirs

EXCLUDE_PARAMS=$(for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
do
	printf " --exclude=$DIR/$1 "
done)

rsync -r $DIR/* $SANDBOX_HOME/$DIRECTORY_WITHIN $EXCLUDE_PARAMS

Mount

firejail $FIREJAIL_ARGS --noblacklist=~/.gradle --private-tmp --private=$SANDBOX_HOME bash -c  "cd ~/$DIRECTORY_WITHIN/ && $COMMAND"

Umount

rm -rf $SANDBOX_HOME/$DIRECTORY_WITHIN


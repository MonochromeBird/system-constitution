#!/bin/sh

MSG="sandbox-exec-directory:
Performs a sandboxed action on a given directory, while only
mirroring changes to certain specified subdirectories and
discarding everything else.

The given directory is copied over (unless the mutable directories
argument is "." or "./") and the mutable subdirectories are mounted.

The script makes use of 'mount --bind', so recursively deleting
files in the specified sandbox home may damage the mirrored
subdirectories. All directories are umounted at the end of the
script, assuming the process manages to survive and the mount
points are not busy."

if [ $# != 7 ]; then
	printf "$MSG\n\n"

	printf "Invalid usage. Syntax:"
	printf " sandbox-exec-directory"
	printf " <target directory>"
	printf " <sandbox home directory>"
	printf " <directory within sandbox home>"
	printf " <comma separated mutable directory list or empty string>"
	printf " <comma separated mutable directory list relative to home or empty string>"
	printf " <firejail extra args or empty string>"
	printf " <command>\n"
	exit 1
fi

SANDBOX_HOME=$2
DIRECTORY_WITHIN=$3
MUTABLE=$4
MUTABLE_RELATIVE_TO_HOME=$5
FIREJAIL_EXTRA_ARGS="$6"
COMMAND=$7

if [ "$COMMAND" = "" ]; then
	COMMAND=ls
fi

FIREJAIL_ARGS="--quiet --blacklist=/conf --novideo --private-tmp --noblacklist=~/.gradle $FIREJAIL_EXTRA_ARGS"

DIR=$1

Umount()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		sudo umount $SANDBOX_HOME/$DIRECTORY_WITHIN/$i || true
	done

	for i in $(echo "$MUTABLE_RELATIVE_TO_HOME" | sed "s/,/\n/g")
	do
		sudo umount $SANDBOX_HOME/$i || true
	done
}

Mount()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		sudo mount --bind $DIR/$i $SANDBOX_HOME/$DIRECTORY_WITHIN/$i
	done

	for i in $(echo "$MUTABLE_RELATIVE_TO_HOME" | sed "s/,/\n/g")
	do
		sudo mount --bind ~/$i $SANDBOX_HOME/$i
	done
}

GetMounted()
{
	mountpoint -q $SANDBOX_HOME/$DIRECTORY_WITHIN && printf "$SANDBOX_HOME/$DIRECTORY_WITHIN\n"

	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		mountpoint -q $SANDBOX_HOME/$DIRECTORY_WITHIN/$i && printf "$SANDBOX_HOME/$DIRECTORY_WITHIN/$i\n"
	done

	for i in $(echo "$MUTABLE_RELATIVE_TO_HOME" | sed "s/,/\n/g")
	do
		mountpoint -q $SANDBOX_HOME/$i && printf "$SANDBOX_HOME/$i\n"
	done
}

AbortIfMounted()
{
	MOUNTED=$(GetMounted)

	if [ $(printf "$MOUNTED" | wc -w) != "0" ]; then
		echo "Some directories are still mounted. Aborting. Proceed with caution when operating on $SANDBOX_HOME."
		printf "Mounted directories:\n$MOUNTED\n"
		exit 1
	fi
}

Mkdirs()
{
	for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
	do
		mkdir -p $SANDBOX_HOME/$DIRECTORY_WITHIN/$i
		mkdir -p $DIR/$i
	done

	for i in $(echo "$MUTABLE_RELATIVE_TO_HOME" | sed "s/,/\n/g")
	do
		mkdir -p $SANDBOX_HOME/$i
		mkdir -p ~/$i
	done
}

Umount
AbortIfMounted

rm -rf $SANDBOX_HOME/$DIRECTORY_WITHIN

Mkdirs

EXCLUDE_PARAMS=$(for i in $(echo "$MUTABLE" | sed "s/,/\n/g")
do
	printf " --exclude=$DIR/$i "
done)

if [ "$EXCLUDE_PARAMS" != "." ] && [ "$EXCLUDE_PARAMS" != "./" ]; then
	rsync -r $DIR/* $SANDBOX_HOME/$DIRECTORY_WITHIN $EXCLUDE_PARAMS
fi

Mount

FIREJAIL_UNBLACKLIST_ARGS=$(for i in $(echo "$MUTABLE_RELATIVE_TO_HOME" | sed "s/,/\n/g")
do
	printf " --noblacklist=~/$i "
done)

firejail $FIREJAIL_ARGS $FIREJAIL_UNBLACKLIST_ARGS --private=$SANDBOX_HOME bash -c  "cd ~/$DIRECTORY_WITHIN/ && $COMMAND"

Umount
AbortIfMounted

rm -rf $SANDBOX_HOME/$DIRECTORY_WITHIN


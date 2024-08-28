#!/bin/sh

BASEDIR=$(dirname $(realpath "$0"))

mkdir -p ~/.config
mkdir -p ~/.config/qutebrowser

sed $BASEDIR/links.csv -e "s/,/ \~\//g" -e "s#.*#ln -sn -T $BASEDIR\/&#g" | sh

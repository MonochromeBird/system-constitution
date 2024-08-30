#!/bin/sh

sudo nixos-rebuild switch --flake $(dirname $0)?submodules=1\#$1 ${@:2}

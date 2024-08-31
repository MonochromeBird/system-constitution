#!/bin/sh

sudo nixos-rebuild switch --flake path:$(dirname $0)\#$1 ${@:2}

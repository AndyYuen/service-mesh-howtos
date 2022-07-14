#! /bin/sh

sed 's/ /#/g' | (echo -n "echo hash: " && cat)


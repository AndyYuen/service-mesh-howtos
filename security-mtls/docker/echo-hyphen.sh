#! /bin/sh

sed 's/ /-/g' | (echo -n "echo hyphen: " && cat)


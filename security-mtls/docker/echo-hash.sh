#! /bin/sh

sed 's/ /#/g' | xargs -n10 echo "echo hash: "


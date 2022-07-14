#! /bin/sh

sed 's/ /*/g' | (echo -n "echo asterisk: " && cat)


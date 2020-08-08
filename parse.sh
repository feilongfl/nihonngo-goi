#!/usr/bin/env fish

cat $argv | jq .data[].wordName > $argv.word
cat $argv | jq .data[].wordDesc > $argv.desc
paste $argv.word $argv.desc > $argv.csv
rm $argv.word $argv.desc

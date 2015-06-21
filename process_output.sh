#!/bin/bash

# each time server log spits out new lines, they will be sent to this
# script via stdin for processing

while read line
do
		# check for player_login event
		if [[ $line =~ \[Server\ thread\/INFO\]:\ [^\[].*the\ game$ ]]; then
				STRING=`echo $line | sed 's/\[.*\]\ \[Server\ thread\/INFO\]:\ //'`
				player=`echo $STRING | awk '{print $1;}'`
				echo "Player login event detected ($player), notification being sent"
				echo $STRING | ./notify.sh others player_login $player
		fi
		# add other event detection scripts here
done

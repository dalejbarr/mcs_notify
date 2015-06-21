#!/bin/bash

# this script sends off notifications based on the player_name / key
# pairs stored in the file player_keys
# 
# notification sent by POSTing a web request to IFTTT
# 
# NOTES: 
#
# - you must have IFTTT secret maker keys for players stored in the
#       player_keys file
# 
# - you must have curl installed on your system
# 
# USAGE:
#   notify.sh [who] [what] [player]
# 
#   where:
#
#     who:    who to notify. either 'all' or 'others'. If 'others', will
#             notify everyone except 'player'
# 
#     what:   name of the event to post (e.g., player_login)
#
#     player: (optional) used in combination with who = 'others'; this
#             is the name of a person who will *not* receive notification
#             (e.g., to prevent yourself from receiving notification when
#             you login)

who=$1
what=$2
player=$3

msg=$(cat)

fire_event() {
		curl -X POST -s -H "Content-Type: application/json" -d "{\"value1\":\"$msg\"}" https://maker.ifttt.com/trigger/${what}/with/key/$key > /dev/null
}

if [ "$who" == 'others' ]
then
		if [ $# -lt 3 ]
		then
				echo "using who = 'others' requires player name as 3rd argument'"
				exit
		fi
fi

if [ -r player_keys ]
then
		while read -r line || [[ -n $player_keys ]]; do
				pname=`echo $line | awk '{print $1;}'`
				key=`echo $line | awk '{print $2;}'`
				if [ "$who" == 'others' ]
				then
						if [ "$pname" != "$player" ]
						then
								fire_event $key
						fi
				else
						fire_event $key
				fi
		done < player_keys
else
		echo "cannot access file player_keys (does it exist?)"
fi

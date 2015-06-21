#!/bin/sh

# Detect when file named by param $1 changes, and run newlines.sh

F=$1
NLINES="wc -l $F | sed 's/ .*$//'"

LAST_N=`eval $NLINES`

while true; do
		CUR_N=`eval $NLINES`
		if [ $CUR_N -gt $LAST_N ]
		then
				# echo "$LAST_N $CUR_N"
				FIRST=$(expr $LAST_N + 1)
				sed -n ''"$FIRST"','"$CUR_N"'p' $F | ./process_output.sh
				LAST_N=$CUR_N
		fi
		sleep 1s
done

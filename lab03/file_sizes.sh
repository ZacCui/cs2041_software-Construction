#!/bin/sh

all="*"
small=""
medi=""
lag=""
for i in $all
do
	line=`wc -l $i | egrep -o [0-9]+`
	if [[ $line -lt 10 ]]
	then small+=" $i"
	elif [[ $line -lt 100  ]]
	then medi+=" $i"
	else lag+=" $i"
	fi
done
echo "Small files:$small"
echo "Medium-sized files:$medi"
echo "Large files:$lag"

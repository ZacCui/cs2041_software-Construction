#!/bin/sh

num_range=5
test_times=1
for(( i=1; i<=$num_range; ++i ))
do
	((test_times=test_times * i))
done
i=0
while [ $i -lt $test_times ]
do
	j=0
	while [ $j -lt $num_range ]
	do
		echo $j
		((j++))
	done |
	./shuffle.pl > /tmp/test.$i
	((++i))
done
count=0
i=0
while [ $i -lt $test_times ]
do
	for data in $(cat "/tmp/test.$i")
	do
		string+="$data"
	done
	for(( j=1; j<$num_range; ++j ))
	do
        	echo $string | grep $j > /dev/null|| echo "Invlid output"
	done
	string=""
        ((++i))
done
rm /tmp/test.*

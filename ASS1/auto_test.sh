#/bin/sh

for i in {0,1,2,3,4,5}
do
	echo "=== Testing test0$i ===="
	`./pypl.pl "test0$i.py" | perl > out`
	`python3 "test0$i.py" > res`
	if diff  "res" "out"
	then
		echo "test case pass!!!!!"
	else
		echo "test case fail :("
	fi
done

name="test.pl"
for i in {0,1,2,3,4,5}
do
	for file in  examples/$i/*.py
	do
		[[ $file =~ "odd" ]]&& continue
		[[ $file =~ "size" ]]&& continue
		base=`echo $file | sed "s/\..*//g"`
		echo "=== Testing $base ===="
		`./pypl.pl "$base.py" > $name`
		`perl $name > out`
		`python3 "$base.py" > res`
		#diff out res && echo passed
		if diff  "res" "out"
		then
			echo "test case pass!!!!!"
		else
			echo "test case fail :("
		fi
	done
done


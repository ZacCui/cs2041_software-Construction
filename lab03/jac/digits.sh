#!\bin\sh

while read data
do
	if [[ "$data" -lt 5 ]]
	then
		echo '<'
	elif [[ "$data" -gt 5 ]]
	then
		echo '>'
	else
		echo "$data"
	fi
done

#!/bin/sh


# print HTTP header
# its best to print the header ASAP because
# debugging is hard if an error stops a valid header being printed
IP=`env|
sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g'|
egrep 'REMOTE_ADDR' |
sed 's/.*=//g'`

host=`host $IP | sed 's/.*pointer //g' |
sed 's/\.$//g' `

BROWSER=`env|
sed 's/&/\&amp;/;s/</\&lt;/g;s/>/\&gt;/g' |
egrep 'HTTP_USER_AGENT' |
sed 's/.*=//g'`

echo Content-type: text/html
echo
cat <<eof
<!DOCTYPE html>
<html lang="en">
<head>
<title>Browser IP, Host and User Agent</title>
</head>
<body>
Your browser is running at IP address: <b>$IP</b>
<p>
Your browser is running on hostname: <b>$host</b>
</p><p>
Your browser identifies as: <b>$BROWSER</b>
</p>
</body>
</html>
eof

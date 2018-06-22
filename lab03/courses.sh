#!/bin/sh
wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=All" "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=All" | grep "$1" |
cat -A |
sed -E 's/(\^I)*//g' |
sed -E 's/<[^<>]*>+//g' |
egrep -v "Use this search" |
sed -E 's/ *\$ *//g'|
sed 'N;s/\n/ /' |
egrep -v "^Thesis"|
sort|
uniq

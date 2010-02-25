#Gmail script

#here are your account settings in plain text
muser=####
mpass=####

mails="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://$muser:$mpass@mail.google.com/mail/feed/atom \
--no-check-certificate 2>/dev/null)"

count=`echo "$mails" | grep fullcount | sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//'`


emails=( `echo "$mails" | grep email | sed -n -e 's/.*<email>\(.*\)<\/email>.*/\1/p'` )

bIFS=$IFS
IFS=$'\012'
titles=( `echo "$mails" | grep title | sed -n -e 's/.*<title>\(.*\)<\/title>.*/\1 \n/p' | sed -e '1d'` )
summaries=( `echo "$mails" | grep summary | sed -n -e 's/.*<summary>\(.*\)<\/summary>.*/\1\n/p'` )
IFS=$bIFS

datetimes=( `echo "$mails" | grep issued | sed -n -e 's/.*<issued>\(.*\)T\(.*\)Z<\/issued>.*/\1;\2;GMT/p'` )

#if [ $count > 5 ]; then
#	count=5
#fi

for ((i=0; i < count; i++)); do
	echo "-$i-----------"
	echo `echo ${datetimes[$i]} | sed -n -e 's/;/ /pg'`
	title=${titles[$i]}
	if [ "$title" == " " ]; then
		title="(no title)"
	fi
        echo $title
	echo "by ${emails[$i]}"
	echo
	echo ${summaries[$i]}
done
echo
echo
#echo "$mails" | grep summary | sed -n -e 's/.*<summary>\(.*\)<\/summary>.*/\1:::::/p'
#echo "$datetimes"
#echo -n "$count"
#echo
#echo "$emails"
#echo $mails

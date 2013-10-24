#!/bin/sh

OKFILE = 'autopdf.done'

if [ ! -d $1 ]; then
	echo " * Unknow repo. Cloning..."
	git clone $2
fi

cd $1
git pull origin master || exit 1
echo " * Repo pulled"

echo " * Beginning pdf rendering..."
make -f Makepdf
echo " * pdf rendering finished..."

if [ -f $OKFILE ]; then
	git add $(cat $OKFILE)
	git commit -m "[autopdf] PDF rendering ($(egrep -h "$(date +"%m/%d|%b* %d")" /usr/share/calendar/* | head -1))"
	rm -f $OKFILE
	echo " * Changes commited"
	git push origin master:$3 || exit 1
	echo " * Changes pushed"
else
	echo " ! No autopdf.done file found"
	exit 1
fi
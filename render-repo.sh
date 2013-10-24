#!/bin/sh

OKFILE='autopdf.done'

if [ ! -d $1 ]; then
	echo " * Unknow repo. Cloning..."
	git clone $2
	cd $1
	git config user.name "autopdf bot"
else
	cd $1
	git checkout -b $3
	git pull --no-edit origin master
	git pull --no-edit origin $3
fi
echo " * Repo pulled"

echo " * Beginning pdf rendering..."
make -Bf Makepdf
echo " * pdf rendering finished..."

if [ -f $OKFILE ]; then
	git add $(head $OKFILE)
	echo " * Changes added"
	git commit -m "[autopdf] PDF rendering ($(egrep -h "$(date +"%m/%d|%b* %d")" /usr/share/calendar/* | head -1))"
	rm -f $OKFILE
	echo " * Changes commited"
	git push origin $3 || exit 1
	echo " * Changes pushed"
else
	echo " ! No autopdf.done file found"
	exit 1
fi

#!/bin/sh

set -v

if [ ! -d $1 ]; then
	echo " * Unknow repo. Cloning..."
	git clone $2
fi

cd $1
git pull origin master

make -f Makepdf || exit 1
git commit *.pdf -m "[autopdf] PDF rendering"
git push origin master:$3 || exit 1

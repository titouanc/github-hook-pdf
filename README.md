github-hook-pdf
===============
Small script to render tex files to pdf, when pushed to master on GitHub.

Installation
============

	virtualenv ve
	source ve/bin/activate
	pip install -r requirements.txt

Usage
=====
On a box reachable from the internet, run

	python server.py

You'll maybe need to set up a reverse proxy.

Then go to a GitHub repo > settings > service hooks.
Add the URL of your github-hook-pdf instance, with path /tex2pdf
Example: `http://my.awesome.server/tex2pdf`

Then add a file called Makepdf, with a Makefile syntax, which describe how to
build the final pdf. It should also produce a file named `autopdf.done` which
contains all files that will be commited by this script.

Make sure the repo is added to the `known_repos` list in server.py.

Push, wait, and check for a branch called autopdf (or whatever name set in 
variable `branch_name` in server.py). If not present after a few
seconds, there was maybe an error in pdf rendering, check the logs.

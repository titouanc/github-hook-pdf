from flask import Flask, request
import json
import subprocess

known_repos = ['Stage-Railnova']
branch_name = "autopdf"

def do_pdf(repo):
	name = repo['name']
	url  = repo['url'].replace('https://github.com/', 'git@github.com:')+'.git'
	print " * Doing pdf for", name
	if subprocess.call(["./render-repo.sh", name, url, branch_name]) != 0:
		print " ! ERROR when rendering repo", name

webapp = Flask(__name__)
@webapp.route("/tex2pdf", methods=['POST'])
def postReceiveHook():
	data = json.loads(request.form['payload'])
	changes_tex = []
	if data['repository']['name'] not in known_repos:
		return "I don't like you. Goodbye"
	if data['ref'].split('/')[-1] == 'master':
		for commit in data['commits']:
			for file_changed in commit['added'] + commit['modified']:
				if file_changed[-4:] == '.tex' or file_changed == 'Makepdf':
					changes_tex.append(file_changed)
		if len(changes_tex)>0:
			do_pdf(data['repository'])
	return "Thx"

if __name__ == "__main__":
    webapp.run()

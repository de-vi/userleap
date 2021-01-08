#!/bin/bash -xe

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt-get update
apt-get install -y build-essential libssl-dev libffi-dev python-dev
apt-get install -y python3-pip
pip3 install virtualenv
mkdir /usr/local/flask_app
cd /usr/local/flask_app
virtualenv -p python3 env3
. env3/bin/activate
python3 --version
which python 
pip3 install Flask

cat <<EOM > hello.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '<html><h1>IT WORKS!</h1></html>'
EOM

export FLASK_APP=hello.py
nohup flask run --host=0.0.0.0 > log.txt 2>&1 &
curl http://localhost:5000/

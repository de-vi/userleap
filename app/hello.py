from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '<html><h1>IT WORKS!</h1></html>'

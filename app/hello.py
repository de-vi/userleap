from flask import Flask
app = Flask(__name__, static_folder='ui')

@app.route('/')
def root():
    return app.send_static_file('index.html')

@app.route('/<path:path>')
def static_file(path):
    return app.send_static_file(path)

@app.route('/test')
def hello_world():
    return '<html><h1>IT WORKS!</h1></html>'

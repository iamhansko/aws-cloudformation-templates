from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello ECS"

@app.route("/health")
def healthcheck():
    return "Healthy"

@app.route("/error")
def error():
    return "Server Error", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

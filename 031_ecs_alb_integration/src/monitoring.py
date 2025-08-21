from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello, ECS Flask!"

@app.route("/error")
def error():
    # 일부러 500 에러를 발생시킴
    return "Internal Server Error Test", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

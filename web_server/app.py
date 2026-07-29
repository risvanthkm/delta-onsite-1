from flask import Flask
import redis

app = Flask(__name__)

r = redis.Redis(
    host="redis",
    port=6379,
    decode_responses=True
)

@app.route("/")
def home():
    r.set("message", "Hello Redis")
    return r.get("message")

app.run(host="0.0.0.0", port=8080)
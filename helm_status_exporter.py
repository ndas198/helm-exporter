from flask import Flask, Response
import subprocess

app = Flask(__name__)

@app.route("/metrics")
def metrics():
    output = subprocess.check_output(["/scripts/helm_status.sh"])
    return Response(output, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9110)

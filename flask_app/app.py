from flask import Flask, render_template
import os
import collections

app = Flask(__name__, template_folder="templates")

IP_MAP = {
    "sftp1": "192.168.198.2",
    "sftp2": "192.168.198.3",
    "sftp3": "192.168.198.4",
}

LOG_DIR = os.path.join(os.getcwd(), "incoming_vm1")

@app.route("/")
def report():
    counts = collections.Counter()
    for fname in os.listdir(LOG_DIR):
        if fname.endswith(".heartbeat"):
            host = fname.split("_", 1)[0]
            counts[host] += 1

    rows = []
    for host, cnt in sorted(counts.items()):
        ip = IP_MAP.get(host, "—")
        rows.append((host, ip, cnt))

    return render_template("report.html", rows=rows)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

from datetime import datetime
import csv
from flask import Flask, render_template, request
import sys
from pathlib import Path


app = Flask(
    __name__,
    template_folder="templates",
    static_folder="static"
)


machines = ["sftp1", "sftp2", "sftp3"]
DATA_DIR = Path("csv_logs")
data_files = [DATA_DIR / f"{m}.csv" for m in machines]

date_format = "%Y-%m-%d"
time_format = "%H:%M:%S"


def load_logs(date: datetime, machine: str) -> dict[str, list[datetime]]:
    target = date.strftime(date_format)
    result: dict[str, list[datetime]] = {}
    for file in data_files:
        entries: list[datetime] = []
        path = Path(file)
        if path.exists():
            with path.open(newline='') as f:
                reader = csv.reader(f, delimiter=',')
                for row in reader:
                    if len(row) < 3:
                        continue
                    m, d, t = row[0], row[1], row[2]
                    if m != machine or d != target:
                        continue
                    try:
                        dt = datetime.strptime(t, time_format)
                        entries.append(dt)
                    except (ValueError, TypeError):
                        continue
        result[file] = entries
    return result


def aggregate_half_hour(entries: list[datetime]) -> list[int]:
    bins = [0] * 48
    for dt in entries:
        idx = dt.hour * 2 + (dt.minute // 30)
        bins[idx] += 1
    return bins

@app.route('/', methods=['GET', 'POST'])
def index():
    selected = None
    selected_machine = None
    slots = [f"{i//2:02d}:{'00' if i%2==0 else '30'}" for i in range(48)]
    data = {}
    has_logs = False

    if request.method == 'POST':
        date_str = request.form.get('date')
        selected_machine = request.form.get('machine')

        if date_str:
            try:
                selected = datetime.strptime(date_str, "%Y-%m-%d")
            except ValueError:
                selected = None

        if selected and selected_machine in machines:
            raw = load_logs(selected, selected_machine)
            for fname, entries in raw.items():
                counts = aggregate_half_hour(entries)
                mmax = max(counts) if any(counts) else 0
                data[fname] = {'counts': counts, 'max': mmax}
                if mmax > 0:
                    has_logs = True

    return render_template(
        'index.html',
        machines=machines,
        selected=selected,
        selected_machine=selected_machine,
        slots=slots,
        data=data,
        has_logs=has_logs
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
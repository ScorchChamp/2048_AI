import json
import matplotlib.pyplot as plt
import time

data_file = "results.json"
plt.ion()  # Turn on interactive mode

while True:
    with open(data_file, "r") as f:
        data = json.load(f)

    data = dict(sorted(data.items(), key=lambda x: int(x[0])))
    x = [int(k) for k in data.keys()]
    y = list(data.values())

    plt.clf()  # Clear the current figure
    plt.plot(x, y)
    plt.xlabel("Time")
    plt.ylabel("Score")
    plt.title("2048 NN score over time")
    plt.draw()
    plt.pause(5)  # Pause briefly to allow the plot to be updated

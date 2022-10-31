class MetricData {
  MetricData(this.name, this.score);

  final String name;
  final int score;
}

class LoginViewModel {
  LoginViewModel();

  List<MetricData> getMetrics() {
    // to replace with api call handling
    return [
      MetricData("Power", 15),
      MetricData("Timing", 25),
      MetricData("Reaction Time", 15),
      MetricData("Agility", 25),
      MetricData("Hand Speed", 20),
    ];
  }

  int getTotalScore() {
    // to replace with api call handling
    return 65;
  }
}

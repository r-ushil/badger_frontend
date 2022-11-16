import 'package:flutter/material.dart';

class DrillData {
  //todo - replace with builder pattern for better readability
  DrillData(this.name, this.metricNames, this.timeTaken, this.thumbnail,
      this.videoUrl, this.description);

  final String name;
  final List<String> metricNames;
  final int timeTaken;
  final Image thumbnail;
  final String videoUrl;
  final String description;
}

// create drill view model
class DrillViewModel {}

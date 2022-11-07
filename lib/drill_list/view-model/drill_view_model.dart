import 'package:badger_frontend/drill_list/model/drill_model.dart';
import 'package:flutter/material.dart';

// create drill view model
class DrillViewModel {
  static Future<List<DisplayableDrill>> getDrillData() {
    const dummyId = "6352414e50c7d61db5d52861";
    return DrillModel.getDrillData(dummyId);

    // to replace with api call handling
    // return [
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    // ];
  }
}

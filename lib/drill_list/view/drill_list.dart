import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/drill_list/view/widgets/drill_card.dart';
import 'package:flutter/material.dart';

class DrillList extends StatefulWidget {
  const DrillList({super.key});

  @override
  State<DrillList> createState() => _DrillList();
}

class _DrillList extends State<DrillList> {
  static const int numberOfDrills = 2;
  static const int coverDriveDrillId = 0;
  static const int katchetBoardDrillId = 1;
  static DisplayableDrill coverDriveDisplayableDrill = DisplayableDrill(
      "Cover Drive", ["Batting"],
      "https://images.pexels.com/photos/3657154/pexels-photo-3657154.jpeg",
      "TODO",
      "Cover drive is a classic shot in cricket that requires great technique and timing to master. This drill will help you analyse both your balance and timing to ensure you deliver the perfect cover shot! ",
      7);
  static DisplayableDrill katchetBoardDisplayableDrill = DisplayableDrill(
      "Katchet Board",
      ["Fielding"],
      "https://cdn.pixabay.com/photo/2014/07/11/22/05/cricket-390557_1280.jpg",
      "TODO",
      "Lightning fast reaction speed will be needed to score highly in this drill! Do your best to catch a ball that ricochets wildly against a katchet board.",
      5);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/drill_list_banner3.webp"),
                      fit: BoxFit.cover)),
              child: Container(
                  height: 50,
                  width: 300,
                  padding: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(50)),
                      color: Colors.green),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose your drill!".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ))),
            ),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    padding: const EdgeInsets.all(7),
                    itemCount: numberOfDrills,
                    itemBuilder: (context, index) {
                      if (index == coverDriveDrillId) {
                        return DrillCard(
                            drill: coverDriveDisplayableDrill,
                        );
                      } else if (index == katchetBoardDrillId) {
                        return DrillCard(
                            drill: katchetBoardDisplayableDrill,
                        );
                      }

                    }
                    ))
          ],
        ),
      ),
    );
  }
}

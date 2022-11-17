import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({Key? key, required this.isImproved}) : super(key: key);

  final bool isImproved;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        decoration: BoxDecoration(
            border: Border.all(color: (isImproved) ? Colors.green : Colors.red),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.white12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.leaderboard, color: Colors.white, size: 60),
            const SizedBox(
              width: 10,
            ),
            Text((isImproved) ? "#3" : "",
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ));
  }
}

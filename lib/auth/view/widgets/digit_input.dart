import 'package:flutter/material.dart';

class DigitInput extends StatelessWidget {
  const DigitInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: const TextField(
          textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        )
    );
  }
}

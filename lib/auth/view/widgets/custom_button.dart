import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.text, this.f, {Key? key}) : super(key: key);

  final String text;
  final Function() f;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: f,
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ));
  }
}

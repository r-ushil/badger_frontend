import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.text, this.goto, {Key? key}) : super(key: key);

  final String text;
  final Widget goto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => goto));
          },
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ));
  }
}

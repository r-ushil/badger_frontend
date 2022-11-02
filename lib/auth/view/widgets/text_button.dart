import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(this.text, this.goto, {super.key});

  final String text;
  final Widget goto;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.grey
      ),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => goto));},
      child: Text(text),
    );
  }
}

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
                style: const TextStyle(fontSize: 50,
                                 fontWeight: FontWeight.bold
                                )
                );
  }
}

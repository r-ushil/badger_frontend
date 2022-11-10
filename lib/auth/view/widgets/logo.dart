import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "images/logo.png",
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 50), // margin after logo
      ],
    );
  }
}

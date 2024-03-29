import 'package:flutter/material.dart';

class TextBoxWithLabelAndIcon extends StatelessWidget {
  const TextBoxWithLabelAndIcon(this.title, this.icon, this.textController,
      {super.key});

  final String title;
  final IconData icon;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10), // margin before textbox
          SizedBox(
              width: 300,
              child: TextField(
                  controller: textController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                      prefixIcon: Icon(icon, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white12))),
        ]);
  }
}

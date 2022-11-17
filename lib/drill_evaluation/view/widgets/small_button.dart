import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(this.text, this.soft, this.f, {Key? key}) : super(key: key);

  final String text;
  final bool soft;
  final Function() f;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: TextButton(
          style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              backgroundColor:
                  (soft) ? Colors.green.withOpacity(0.5) : Colors.green,
              foregroundColor: Colors.white),
          onPressed: f,
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ));
  }
}

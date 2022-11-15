import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view-model/login_view_model.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(this.text, this.f, {super.key});

  final String text;
  final Function() f;

  @override
  Widget build(BuildContext context) {
    final LoginViewModel lvm = LoginViewModel();

    return TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.grey),
        onPressed: f,
        child: RichText(
            text: TextSpan(style: const TextStyle(fontSize: 20), children: [
          TextSpan(text: lvm.getMainText(text)),
          TextSpan(
              text: lvm.getUnderlined(text),
              style: const TextStyle(decoration: TextDecoration.underline))
        ])));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';
import 'package:badger_frontend/auth/view/widgets/textbox_with_label_and_icon.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';

import 'auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        const Center(child: Logo()),
        const Header("WELCOME"),
        const SizedBox(height: 50), // margin welcome text
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextBoxWithLabelAndIcon(
                "Phone Number", Icons.phone, phoneNumberController),
          ],
        ),
        const SizedBox(height: 20),
        CustomButton("Login", f),
        //const CustomTextButton("Need an account? SIGNUP", Signup()),
      ])),
    );
  }

  void f() {
    if (kDebugMode) {
      print(phoneNumberController.text);
    } // TODO: this is the input phone number from the text field.

    //TODO: change function to verify phone number
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Auth()));
  }
}

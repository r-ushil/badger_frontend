import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/auth/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';
import 'package:badger_frontend/auth/view/widgets/textbox_with_label_and_icon.dart';
import 'package:badger_frontend/auth/view/widgets/custom_text_button.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: Column(
          children: <Widget>[
            const Center(child: Logo()),
            const Header("WELCOME"),
            const SizedBox(height: 50), // margin welcome text
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const <Widget>[
                TextBoxWithLabelAndIcon("Phone Number", Icons.phone),
                //TextBoxWithLabelAndIcon("Password", Icons.lock),
                //CustomTextButton("Forgot your Password?", Dashboard()), //TODO
              ],
            ),
            const SizedBox(height: 20),
            const CustomButton("Login", Auth()),
            //const CustomTextButton("Need an account? SIGNUP", Signup()),
          ])),
    );
  }
}

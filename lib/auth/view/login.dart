import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/auth/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/welcome_header.dart';
import 'package:badger_frontend/auth/view/widgets/phone_textbox.dart';
import 'package:badger_frontend/auth/view/widgets/text_button.dart';
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
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(child: Column(
          children: const <Widget>[
            Center(child: Logo()),
            Header("WELCOME"),
            SizedBox(height: 50), // margin welcome text
            TextBoxWithLabelAndIcon("Phone Number", Icons.phone),
            TextBoxWithLabelAndIcon("Password", Icons.lock),
            CustomTextButton("Forgot your Password?", Dashboard()), //TODO
            SizedBox(height: 20),
            CustomButton("Login", Dashboard()),
            CustomTextButton("Need an account? SIGNUP", Signup()),
          ])),
    );
  }
}

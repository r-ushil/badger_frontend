import 'package:badger_frontend/auth/view/login.dart';
import 'package:badger_frontend/auth/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';
import 'package:badger_frontend/auth/view/widgets/textbox_with_label_and_icon.dart';
import 'package:badger_frontend/auth/view/widgets/custom_text_button.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child: Column(
          children: <Widget>[
            const Center(child: Header("REGISTER")),
            const SizedBox(height: 30), // margin
            Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Column(children: const [
                  TextBoxWithLabelAndIcon("Phone Number", Icons.phone),
                  TextBoxWithLabelAndIcon("Full Name", Icons.person),
                  TextBoxWithLabelAndIcon("Password", Icons.lock),
            ],)),
            const SizedBox(height: 20),
            const CustomButton("Sign up", Auth()),
            const CustomTextButton("Already a user? LOGIN", Login()),
          ])),
    );
  }
}

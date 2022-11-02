import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/auth/view/login.dart';
import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/welcome_header.dart';
import 'package:badger_frontend/auth/view/widgets/phone_textbox.dart';
import 'package:badger_frontend/auth/view/widgets/text_button.dart';
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
      //resizeToAvoidBottomInset: false,
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
            const CustomButton("Sign up", Dashboard()), // TODO
            const CustomTextButton("Already a user? LOGIN", Login()),
          ])),
    );
  }
}

import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
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
            WelcomeHeader(),
            SizedBox(height: 50), // margin welcome text
            TextBoxWithLabelAndIcon("Phone Number", Icons.phone),
            TextBoxWithLabelAndIcon("Password", Icons.lock),
            CustomTextButton("Forgot your Password?"),
            SizedBox(height: 20),
            CustomButton("Login", Dashboard()),
            CustomTextButton("Need an account? SIGNUP"),
          ])),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DrillList()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //bottomNavigationBar: const BottomTabBar(),
    );
  }
}

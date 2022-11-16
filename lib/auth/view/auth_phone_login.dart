import 'package:badger_frontend/common/auth/auth_phone_model.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/logo.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';
import 'package:badger_frontend/auth/view/widgets/textbox_with_label_and_icon.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AuthPhoneLogin extends StatefulWidget {
  const AuthPhoneLogin({Key? key}) : super(key: key);

  @override
  State<AuthPhoneLogin> createState() => _AuthPhoneLoginState();
}

class _AuthPhoneLoginState extends State<AuthPhoneLogin> {
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authPhoneVerify = Provider.of<BadgerAuthPhoneModel>(context);

    void onSubmitPhoneNumber() async {
      Navigator.pushNamed(context, "/auth/phone/verify");

      await authPhoneVerify.signInWithPhoneNumber(phoneNumberController.text);
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode current = FocusScope.of(context);

        if (current.hasPrimaryFocus) return;

        current.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
              CustomButton(
                "Login",
                onSubmitPhoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:badger_frontend/auth/view/widgets/digit_input.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/custom_text_button.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            const Text("Verify your Number \n"),
            const Text(
              "A 6-digit code is sent to ***-***-****.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Please confirm your account by entering the code.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // margin
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                DigitInput(),
                DigitInput(),
                DigitInput(),
                DigitInput(),
                DigitInput(),
                DigitInput(),
              ],
            ),
            const SizedBox(height: 30), // margin
            CustomButton("Verify", f), // TODO
            const CustomTextButton(
                "Didn't get the code? RESEND", Auth()), //TODO
          ])),
    );
  }

  void f() {
    //TODO: change it to verify phone number
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Auth()));
  }
}

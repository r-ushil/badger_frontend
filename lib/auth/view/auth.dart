import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/custom_text_button.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String? _verificationCode;

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
              "A 6-digit code is sent to you.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Padding(
                padding: EdgeInsets.all(2),
                child: Text(
                  "Please confirm your account by entering the code.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 30), // margin
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerificationCode(
                    length: 6,
                    underlineColor: Colors.green,
                    underlineWidth: 2,
                    fullBorder: true,
                    autofocus: true,
                    textStyle: const TextStyle(color: Colors.white),
                    onCompleted: (String valueRead) {
                      _verificationCode = valueRead;
                      setState(() {});
                    },
                    onEditing: (bool isCurrentlyEditing) {
                      if (!isCurrentlyEditing) {
                        FocusScope.of(context).unfocus();
                      }
                    }),
              ],
            ),
            const SizedBox(height: 30), // margin
            CustomButton("Verify", f), // TODO
            CustomTextButton("Didn't get the code? RESEND", f), // TODO
          ])),
    );
  }

  void f() {
    if (kDebugMode) {
      print(_verificationCode);
    } //TODO: this is your input verification code in the text field

    //TODO: change it to verify phone number
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }
}

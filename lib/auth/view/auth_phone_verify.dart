import 'package:badger_frontend/common/auth/auth_phone_model.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/custom_button.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';

class AuthPhoneVerify extends StatefulWidget {
  const AuthPhoneVerify({Key? key}) : super(key: key);

  @override
  State<AuthPhoneVerify> createState() => _AuthPhoneVerifyState();
}

class _AuthPhoneVerifyState extends State<AuthPhoneVerify> {
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    final authPhoneVerify = Provider.of<BadgerAuthPhoneModel>(context);

    void onSubmitOtp() async {
      String? otp = _verificationCode;
      if (otp == null) return;

      await authPhoneVerify.verifyPhoneNumberWithOtp(otp);
    }

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
            const SizedBox(height: 30),
            CustomButton("Verify", onSubmitOtp),
          ])),
    );
  }
}

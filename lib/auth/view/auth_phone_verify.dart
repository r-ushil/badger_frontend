import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/auth_phone_model.dart';

class AuthPhoneVerify extends StatelessWidget {
  AuthPhoneVerify({Key? key}) : super(key: key);

  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authPhoneVerify = Provider.of<AuthPhoneVerificationModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login with Phone Number")),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Verify Phone Number with OTP'),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP Code'),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () async {
                await authPhoneVerify
                    .verifyPhoneNumberWithOtp(otpController.text);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:badger_frontend/auth/model/auth_phone_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class AuthPhoneLogin extends StatelessWidget {
  AuthPhoneLogin({Key? key}) : super(key: key);

  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final authPhoneVerify = Provider.of<AuthPhoneVerificationModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode current = FocusScope.of(context);

        if (current.hasPrimaryFocus) return;

        current.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Login with Phone Number'),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(),
                ],
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, "/auth/phone/verify");

                  await authPhoneVerify
                      .signInWithPhoneNumber(phoneNumberController.text);
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

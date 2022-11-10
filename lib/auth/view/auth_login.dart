import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AuthLogin extends StatelessWidget {
  AuthLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onSelectAuthPhone() {
      Navigator.pushNamed(context, "auth");
    }

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
              const Text('Select Login Method'),
              ElevatedButton(
                onPressed: onSelectAuthPhone,
                child: const Text('Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

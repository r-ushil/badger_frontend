import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('WELCOME',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50,
                                 fontWeight: FontWeight.bold
                                )
                );
  }
}

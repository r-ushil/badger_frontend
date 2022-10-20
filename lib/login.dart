import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  static const String _title = 'Badger';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController numberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Badger',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: numberController.text,
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {},
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );

                    await auth.verifyPhoneNumber(
                      phoneNumber: numberController.text,
                      verificationCompleted: (PhoneAuthCredential credential) async {
                        // ANDROID ONLY!
                        // Sign the user in (or link) with the auto-generated credential
                        final userCredential = await auth.signInWithCredential(credential);
                        final user = userCredential.user;
                        print(user?.uid);
                      },
                      verificationFailed: (FirebaseAuthException error) {
                        if (error.code == 'invalid-phone-number') {
                          // tell user invalid number
                          print('The provided phone number is not valid.');
                        }
                      },
                      codeSent: (String verificationId, int? forceResendingToken) async {
                        // Update the UI - wait for the user to enter the SMS code
                        String smsCode = 'xxxx';

                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        // Auto-resolution timed out...
                      },
                    );
                  },
                )
            ),
          ],
        ));
  }
}
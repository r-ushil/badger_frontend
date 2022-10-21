import 'package:flutter/foundation.dart';
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
  TextEditingController codeController = TextEditingController();
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
                alignment: Alignment.center,
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

                    await auth.verifyPhoneNumber(
                      phoneNumber: numberController.text,
                      verificationCompleted: (PhoneAuthCredential credential) async {
                        // ANDROID ONLY!
                        // Sign the user in (or link) with the auto-generated credential
                        final userCredential = await auth.signInWithCredential(credential);
                        final user = userCredential.user;
                        if (kDebugMode) {
                          print(user?.uid);
                        }
                        Navigator.of(context).pushNamed("home");
                      },
                      verificationFailed: (FirebaseAuthException error) {
                        if (error.code == 'invalid-phone-number') {
                          const Text("The provided phone number is not valid",
                            textAlign: TextAlign.center,);
                          if (kDebugMode) {
                            print('The provided phone number is not valid.');
                          }
                        }
                      },
                      codeSent: (String verificationId, int? forceResendingToken) async {
                        // Update the UI - wait for the user to enter the SMS code
                        Container(
                          alignment: Alignment.center,
                          child: TextField(
                            controller: codeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'SMS code',
                            ),
                          ),
                        );
                        const Text("Enter SMS code",
                          textAlign: TextAlign.center,);

                        String smsCode = codeController.text;

                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

                        // Sign the user in (or link) with the credential
                        final userCredential =  await auth.signInWithCredential(credential);
                        final user = userCredential.user;
                        if (kDebugMode) {
                          print(user?.uid);
                        }
                        Navigator.of(context).pushNamed("home");
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        // Auto-resolution timed out...
                        const Text("Auto-resultion timed out",
                          textAlign: TextAlign.center,);
                      },
                    );
                  },
                )
            ),
          ],
        ));
  }
}
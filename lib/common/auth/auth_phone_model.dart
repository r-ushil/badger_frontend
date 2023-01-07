import 'package:firebase_auth/firebase_auth.dart';
import 'package:badger_frontend/api_models/badger-api/person/v1/person_api.pbgrpc.dart'
    as person_api;
import 'package:badger_frontend/api_models/api_client_channel.dart' as client_channel;
import 'package:grpc/grpc.dart';

enum BadgerAuthPhoneState {
  waitingForPhoneNumber,
  waitingForVerification,
  completed,
}

class BadgerAuthPhoneModel {
  final auth = FirebaseAuth.instance;

  String? _verificationId;
  BadgerAuthPhoneState progress = BadgerAuthPhoneState.waitingForPhoneNumber;

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    if (progress != BadgerAuthPhoneState.waitingForPhoneNumber) return;

    progress = BadgerAuthPhoneState.waitingForVerification;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  Future<void> verifyPhoneNumberWithOtp(String otp) async {
    String? verificationId = _verificationId;
    if (verificationId == null) return;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await auth.signInWithCredential(credential).then((credential) async {
          if (credential.additionalUserInfo!.isNewUser) { 
            final personServiceClient = person_api.PersonServiceClient(
                client_channel.ApiClientChannel.getClientChannel(),
                options: CallOptions(timeout: const Duration(minutes: 1)));
            try {
              var res = await personServiceClient.insertNewUser(person_api.InsertNewUserRequest(firebaseId: credential.user!.uid));
              return res.hexId;
            } catch (e) {
              rethrow;
              //TODO: error handling
            }
    }});

    _verificationId = null;
  }

  Future<void> _verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);

    progress = BadgerAuthPhoneState.completed;
    _verificationId = null;
  }

  void _verificationFailed(FirebaseAuthException e) {
    print(e);
  }

  void _codeSent(String verificationId, int? resendToken) async {
    progress = BadgerAuthPhoneState.waitingForVerification;
    _verificationId = verificationId;
  }

  void _codeAutoRetrievalTimeout(String verificationId) {}
}

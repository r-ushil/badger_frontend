import 'package:firebase_auth/firebase_auth.dart';

enum AuthPhoneVerificationState {
  waitingForPhoneNumber,
  waitingForVerification,
  completed,
}

class AuthPhoneVerificationModel {
  final auth = FirebaseAuth.instance;

  String? _verificationId;
  AuthPhoneVerificationState progress =
      AuthPhoneVerificationState.waitingForPhoneNumber;

  void signInWithPhoneNumber(String phoneNumber) async {
    if (progress != AuthPhoneVerificationState.waitingForPhoneNumber) return;

    progress = AuthPhoneVerificationState.waitingForVerification;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  void verifyPhoneNumberWIthOtp(String otp) async {
    String? verificationId = _verificationId;
    if (verificationId == null) return;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await auth.signInWithCredential(credential);

    _verificationId = null;
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);

    progress = AuthPhoneVerificationState.completed;
    _verificationId = null;
  }

  void _verificationFailed(FirebaseAuthException e) {}

  void _codeSent(String verificationId, int? resendToken) async {
    progress = AuthPhoneVerificationState.waitingForVerification;
    _verificationId = verificationId;
  }

  void _codeAutoRetrievalTimeout(String verificationId) {}
}

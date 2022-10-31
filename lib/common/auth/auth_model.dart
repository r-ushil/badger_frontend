import 'package:firebase_auth/firebase_auth.dart';

class BadgerUser {
  final User _user;

  BadgerUser(this._user);

  static BadgerUser? fromFirebaseUser(User? user) {
    if (user == null) return null;

    return BadgerUser(user);
  }

  String getId() {
    return _user.uid;
  }

  Future<String> getJwt() {
    return _user.getIdToken();
  }
}

class BadgerAuth {
  final Stream<BadgerUser?> _authStateChanges =
      FirebaseAuth.instance.authStateChanges().map(BadgerUser.fromFirebaseUser);

  BadgerAuth();

  authStateChanges() {
    return _authStateChanges;
  }
}

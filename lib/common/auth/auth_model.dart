import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class BadgerUser {
  final User _user;

  BadgerUser(this._user);

  String getId() {
    return _user.uid;
  }

  Future<String> getJwt() {
    return _user.getIdToken();
  }
}

class BadgerAuthState {
  final BadgerUser? _user;

  BadgerAuthState(this._user);

  static BadgerAuthState fromFirebaseUser(User? user) {
    var badgerUser = user != null ? BadgerUser(user) : null;
    return BadgerAuthState(badgerUser);
  }

  bool isLoggedIn() {
    return _user != null;
  }
}

class BadgerAuth {
  final Stream<BadgerAuthState> _authStateChanges = FirebaseAuth.instance
      .authStateChanges()
      .map(BadgerAuthState.fromFirebaseUser);

  BadgerAuth() : assert(Firebase.apps.isNotEmpty);

  authStateChanges() {
    return _authStateChanges;
  }

  initiateSignInWithPhoneNumber(String phoneNumber) {}

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}

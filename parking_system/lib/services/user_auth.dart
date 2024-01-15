import 'package:firebase_auth/firebase_auth.dart';

import '../utils/Utils.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class UserAuth {

  AuthStatus status = AuthStatus.successful;

  Future<UserCredential?> signIn(String login, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      showToast(e.code.replaceAll(RegExp(r'[_-]'), ' ').toLowerCase());
      return null;
    }
  }

  Future<UserCredential?> signUp(String login, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: login, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      showToast(e.code.replaceAll(RegExp(r'[_-]'), ' ').toLowerCase());
      return null;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<AuthStatus> resetPassword(String login) async {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: login).then((value) => status = AuthStatus.successful).
      catchError((e) {
        status = AuthException.handleAuthException(e);
        showToast(e.code.replaceAll(RegExp(r'[_-]'), ' ').toLowerCase());
        return status;
      });
      return status;
  }

}

class AuthException{
  static handleAuthException(FirebaseAuthException e){
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }
}
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

  Future<String?> getCurrentUserUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user?.uid;
  }

  // Change password
  Future<void> changePassword(
      String email, String oldPassword, String newPassword) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      // Reauthenticate user with old password
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
    } catch (e) {
      // Handle error (e.g., weak password, wrong password)
      showToast(e.toString());
    }
  }
}

class AuthException {
  static handleAuthException(FirebaseAuthException e) {
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

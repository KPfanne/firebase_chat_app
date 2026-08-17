import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/service/user_service.dart';

class UserAuthService {
  final UserService _userService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserAuthService(this._userService);

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _userService.addUser({
        "uid": _auth.currentUser!.uid,
        "email": email,
        "name": name,
      });
    } catch (e) {
      log("Registrierung fehlgeschlagen");
      throw Exception(e);
    }
  }

  Stream<User?> get currentUserStream => _auth.authStateChanges();

  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    log("Erfolgreich ausgeloggt");
    await _auth.signOut();
  }
}

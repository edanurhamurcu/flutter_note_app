// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isSignUp = false;

  User? get user => _user;
  bool get isSignUp => _isSignUp;

  AuthProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    if (userEmail != null) {
      _user = _auth.currentUser;
    }
    notifyListeners();
  }

  Future<void> _saveUser(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('userEmail', user.email ?? '');
    } else {
      await prefs.remove('userEmail');
    }
  }

  void toggleAuthMode() {
    _isSignUp = !_isSignUp;
    notifyListeners();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String surname,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName('$name $surname');
      _user = userCredential.user;
      await _saveUser(_user);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      await _saveUser(_user);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw "Google oturum açma iptal edildi.";
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      await _saveUser(_user);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _isSignUp = false;
    await _saveUser(null);
    notifyListeners();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    }
  }

  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        throw LocaleKeys.error_auth_email_exists.tr();
      case 'user-not-found':
        throw LocaleKeys.error_auth_user_not_found.tr();
      case 'wrong-password':
        throw LocaleKeys.error_wrong_password.tr();
      case 'user-disabled':
        throw LocaleKeys.error_disabled_account.tr();
      case 'too-many-requests':
        throw LocaleKeys.error_many_requests.tr();
      case 'operation-not-allowed':
        throw LocaleKeys.error_operation_not_allowed.tr();
      case 'weak-password':
        throw LocaleKeys.error_weak_password.tr();
      case 'invalid-email':
        throw LocaleKeys.error_auth_email_invalid.tr();
      case 'invalid-credential':
        throw LocaleKeys.error_auth_invalid_credentials.tr();
      default:
        throw e.message ?? "Bir hata oluştu.";
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      throw e.message ?? "Kayıt sırasında bir hata oluştu.";
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
      throw e.message ?? "Giriş sırasında bir hata oluştu.";
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
      throw e.message ?? "Google ile giriş sırasında bir hata oluştu.";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    await _saveUser(null);
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException   catch (e) {
      print(e);
    }
  }

 Future<void> signUp(
    String email, String password, String phone, String username) async {
  try {
    await _auth
        .createUserWithEmailAndPassword(email: email.toString().trim(), password: password)
        .then((value) async {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("users")
          .add({
            // 'uid': user?.uid,
            'email': email.toString().trim(),
            'password': password,
            'username': username,
            'phone number': phone,
          });
    });
  } on FirebaseAuthException catch (e) {
    print(e);
  }
}

}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirebaseAuthService {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow; // Throw the error so it can be caught in the _signUp function
    }
  }

  Future<User?> logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow; // Throw the error so it can be caught in the _signUp function
    }
  }

  Future<User?> signUpWithPhoneNumber(String phoneNumber) async {
    try {
      // Implement phone number sign-up logic here
      // You can use Firebase phone number verification or any other method you prefer
      // Make sure to return the signed-up user
    } catch (e) {
      rethrow; // Throw the error so it can be caught in the _signUp function
    }
    return null;
  }
  
}
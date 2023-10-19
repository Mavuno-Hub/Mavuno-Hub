import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'log_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String role = 'user';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    setState(() {
      role = snap['role'];
    });

    if(role == 'user'){
      navigateNext(const LogInUser());
    } else if(role == 'admin'){
      navigateNext(const LogInUser());
    }
  }

  void navigateNext(Widget route) {
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome'),
          ],
        ),
      ),
    );
  }
}
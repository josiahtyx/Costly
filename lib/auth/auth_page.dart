import 'package:costlynew/pages/login.dart';
import 'package:costlynew/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userID = FirebaseAuth.instance.currentUser?.uid;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
